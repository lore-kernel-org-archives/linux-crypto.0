From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v3] crypto: Add IV generation algorithms
Date: Wed, 18 Jan 2017 17:21:47 +0200
Message-ID: <CAOtvUMfhethgZ8TarKGDumL1W5fgjwy1Hi7f88mmCCD6vJ_hLg@mail.gmail.com>
References: <1484732425-10319-1-git-send-email-binoy.jayan@linaro.org> <1484732425-10319-2-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113f2784aecc1805465ff935
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Milan Broz <gmazyland@gmail.com>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484732425-10319-2-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--001a113f2784aecc1805465ff935
Content-Type: text/plain; charset=UTF-8

Hi Binoy,


On Wed, Jan 18, 2017 at 11:40 AM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> Currently, the iv generation algorithms are implemented in dm-crypt.c.
> The goal is to move these algorithms from the dm layer to the kernel
> crypto layer by implementing them as template ciphers so they can be
> implemented in hardware for performance. As part of this patchset, the
> iv-generation code is moved from the dm layer to the crypto layer and
> adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> at a time. Each bio contains an in memory representation of physically
> contiguous disk blocks. The dm layer sets up a chained scatterlist of
> these blocks split into physically contiguous segments in memory so that
> DMA can be performed. Also, the key management code is moved from dm layer
> to the cryto layer since the key selection for encrypting neighboring
> sectors depend on the keycount.
>
> Synchronous crypto requests to encrypt/decrypt a sector are processed
> sequentially. Asynchronous requests if processed in parallel, are freed
> in the async callback. The dm layer allocates space for iv. The hardware
> implementations can choose to make use of this space to generate their IVs
> sequentially or allocate it on their own.
> Interface to the crypto layer - include/crypto/geniv.h
>
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> ---

I have some review comments and a bug report -

<snip>

>   */
> -static int crypt_convert(struct crypt_config *cc,
> -                        struct convert_context *ctx)
> +
> +static int crypt_convert_bio(struct crypt_config *cc,
> +                            struct convert_context *ctx)
>  {
> +       unsigned int cryptlen, n1, n2, nents, i = 0, bytes = 0;
> +       struct skcipher_request *req;
> +       struct dm_crypt_request *dmreq;
> +       struct geniv_req_info rinfo;
> +       struct bio_vec bv_in, bv_out;
>         int r;
> +       u8 *iv;
>
>         atomic_set(&ctx->cc_pending, 1);
> +       crypt_alloc_req(cc, ctx);
> +
> +       req = ctx->req;
> +       dmreq = dmreq_of_req(cc, req);
> +       iv = iv_of_dmreq(cc, dmreq);
>
> -       while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
> +       n1 = bio_segments(ctx->bio_in);
> +       n2 = bio_segments(ctx->bio_in);


I'm pretty sure this needs to be

 n2 = bio_segments(ctx->bio_out);

> +       nents = n1 > n2 ? n1 : n2;
> +       nents = nents > MAX_SG_LIST ? MAX_SG_LIST : nents;
> +       cryptlen = ctx->iter_in.bi_size;
>
> -               crypt_alloc_req(cc, ctx);
> +       DMDEBUG("dm-crypt:%s: segments:[in=%u, out=%u] bi_size=%u\n",
> +               bio_data_dir(ctx->bio_in) == WRITE ? "write" : "read",
> +               n1, n2, cryptlen);
>
<Snip>

>
> -               /* There was an error while processing the request. */
> -               default:
> -                       atomic_dec(&ctx->cc_pending);
> -                       return r;
> -               }
> +               sg_set_page(&dmreq->sg_in[i], bv_in.bv_page, bv_in.bv_len,
> +                           bv_in.bv_offset);
> +               sg_set_page(&dmreq->sg_out[i], bv_out.bv_page, bv_out.bv_len,
> +                           bv_out.bv_offset);
> +
> +               bio_advance_iter(ctx->bio_in, &ctx->iter_in, bv_in.bv_len);
> +               bio_advance_iter(ctx->bio_out, &ctx->iter_out, bv_out.bv_len);
> +
> +               bytes += bv_in.bv_len;
> +               i++;
>         }
>
> -       return 0;
> +       DMDEBUG("dm-crypt: Processed %u of %u bytes\n", bytes, cryptlen);
> +
> +       rinfo.is_write = bio_data_dir(ctx->bio_in) == WRITE;

Please consider wrapping the above boolean expression in parenthesis.


> +       rinfo.iv_sector = ctx->cc_sector;
> +       rinfo.nents = nents;
> +       rinfo.iv = iv;
> +
> +       skcipher_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,

Also, where do the scatterlist src2 and dst2 that you use
sg_set_page() get sg_init_table() called on?
I couldn't figure it out...

Last but not least, when performing the following sequence on Arm64
(on latest Qemu Virt platform) -

1. cryptsetup luksFormat fs3.img
2. cryptsetup open --type luks fs3.img croot
3. mke2fs /dev/mapper/croot


[ fs3.img is a 16MB file for loopback ]

The attached kernel panic happens. The same does not occur without the patch.

Let me know if you need any additional information to recreate it.

I've tried to debug it a little but did not came up with anything
useful aside from above review notes.

Thanks!


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

--001a113f2784aecc1805465ff935
Content-Type: text/plain; charset=US-ASCII; name="panic.txt"
Content-Disposition: attachment; filename="panic.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iy33j8o70

IyAKIyAKIyBtawpta2RpciAgICAgbWtkb3NmcyAgIG1rZTJmcyAgICBta2ZpZm8gICAgbWtub2Qg
ICAgIG1rcGFzc3dkICBta3N3YXAgICAgbWt0ZW1wCiMgbWsKbWtkaXIgICAgIG1rZG9zZnMgICBt
a2UyZnMgICAgbWtmaWZvICAgIG1rbm9kICAgICBta3Bhc3N3ZCAgbWtzd2FwICAgIG1rdGVtcAoj
IG1rZTJmcyAvZGV2L21hcHBlci9jcm9vdCAKRmlsZXN5c3RlbSBsYWJlbD0KT1MgdHlwZTogTGlu
dXgKQmxvY2sgc2l6ZT0xMDI0IChsb2c9MCkKRnJhZ21lbnQgc2l6ZT0xMDI0IChsb2c9MCkKMzU4
NCBpbm9kZXMsIDE0MzM2IGJsb2Nrcwo3MTYgYmxvY2tzICg1JSkgcmVzZXJ2ZWQgZm9yIHRoZSBz
dXBlciB1c2VyCkZpcnN0IGRhdGEgYmxvY2s9MQpNYXhpbXVtIGZpbGVzeXN0ZW0gYmxvY2tzPTI2
MjE0NAoyIGJsb2NrIGdyb3Vwcwo4MTkyIGJsb2NrcyBwZXIgZ3JvdXAsIDgxOTIgZnJhZ21lbnRz
IHBlciBncm91cAoxNzkyIGlub2RlcyBwZXIgZ3JvdXAKU3VwZXJibG9jayBiYWNrdXBzIHN0b3Jl
ZCBvbiBibG9ja3M6Cgk4MTkzClsgMTI4OC40NzUzNzNdIFVuYWJsZSB0byBoYW5kbGUga2VybmVs
IHBhZ2luZyByZXF1ZXN0IGF0IHZpcnR1YWwgYWRkcmVzcyAwMDAwMTAyOApbIDEyODguNDgzNTY4
XSBwZ2QgPSBmZmZmMDAwMDA5M2VkMDAwClsgMTI4OC40ODM3MDhdIFswMDAwMTAyOF0gKnBnZD0w
MDAwMDAwMGJlZmZlMDAzLCAqcHVkPTAwMDAwMDAwYmVmZmQwMDMsICpwbWQ9MDAwMDAwMDAwMDAw
MDAwMApbIDEyODguNDg0MDcxXSBJbnRlcm5hbCBlcnJvcjogT29wczogOTYwMDAwMDYgWyMxXSBQ
UkVFTVBUIFNNUApbIDEyODguNDg0MjY2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAxMjg4LjQ4NDUy
Nl0gQ1BVOiAwIFBJRDogMTYgQ29tbToga3dvcmtlci91MjoxIE5vdCB0YWludGVkIDQuMTAuMC1y
YzQtMDA4MDUtZzlhNGMzMDkgIzMyClsgMTI4OC40ODQ3MTJdIEhhcmR3YXJlIG5hbWU6IGxpbnV4
LGR1bW15LXZpcnQgKERUKQpbIDEyODguNDg1MjMzXSBXb3JrcXVldWU6IGtjcnlwdGQga2NyeXB0
ZF9jcnlwdApbIDEyODguNDg1Mzg1XSB0YXNrOiBmZmZmODAwMDdjNGFiZTgwIHRhc2suc3RhY2s6
IGZmZmY4MDAwN2M0ZGMwMDAKWyAxMjg4LjQ4NTU3Ml0gUEMgaXMgYXQgc2NhdHRlcndhbGtfY29w
eWNodW5rcysweDE0NC8weDFlOApbIDEyODguNDg1NzUwXSBMUiBpcyBhdCBzY2F0dGVyd2Fsa19j
b3B5Y2h1bmtzKzB4ZGMvMHgxZTgKWyAxMjg4LjQ4NTkwNF0gcGMgOiBbPGZmZmYwMDAwMDgzNGY0
NmM+XSBsciA6IFs8ZmZmZjAwMDAwODM0ZjQwND5dIHBzdGF0ZTogMjAwMDAxNDUKWyAxMjg4LjQ4
NjExNV0gc3AgOiBmZmZmODAwMDdjNGRmYTUwClsgMTI4OC40ODYyNjRdIHgyOTogZmZmZjgwMDA3
YzRkZmE1MCB4Mjg6IDAwMDAwMDAwMDAwMDAwMDEgClsgMTI4OC40ODY1MzldIHgyNzogZmZmZjgw
MDA3YzRhYmU4MCB4MjY6IGZmZmY4MDAwN2JhY2FiODEgClsgMTI4OC40ODY3MDldIHgyNTogZmZm
ZjgwMDA3YzRkZmI3MCB4MjQ6IDAwMDAwMDAwMDAwMDAwMGYgClsgMTI4OC40ODY4NTBdIHgyMzog
MDAwMDAwMDAwMDAwMDAwMSB4MjI6IDAwMDAwMDAwMDAwMDAwMDEgClsgMTI4OC40ODY5OTFdIHgy
MTogMDAwMDgxZmZmZmZmZmZmZiB4MjA6IGZmZmY4MDAwN2M0YWJlODAgClsgMTI4OC40ODczNjJd
IHgxOTogZmZmZjgwMDA3YzRhYmU4MCB4MTg6IDAwMDAwMDAwMDAwMDAwMDEgClsgMTI4OC40ODc1
NDRdIHgxNzogMDAwMDAwMDAwMDRiMzc2OCB4MTY6IGZmZmYwMDAwMDgxZWM2NzggClsgMTI4OC40
ODc2OTZdIHgxNTogZmZmZmZmZmZmZmZmZmZmZiB4MTQ6IGZmZmY4MDAwN2JhYjdjODggClsgMTI4
OC40ODc4NDZdIHgxMzogMDAwMDAwMDEwMDAwMDAwMCB4MTI6IDAwMDAwMDAwMDAwMDAwMDAgClsg
MTI4OC40ODc5OTVdIHgxMTogMDAwMDAwMDAwMDAwMDAxMCB4MTA6IDAwMDAwMDAwMDAwMDAyMDAg
ClsgMTI4OC40ODgxNzhdIHg5IDogMDAwMDAwMDAwMDAwMDAwMCB4OCA6IDAwMDAwMDAwMDAwMDAw
MDAgClsgMTI4OC40ODgzMzldIHg3IDogMDAwMDAwMDAwMDAwMDAwMSB4NiA6IGZmZmY4MDAwMDAw
NDAyMDEgClsgMTI4OC40ODg1NDBdIHg1IDogZmZmZjgwMDA3YmE4NWI2OCB4NCA6IDAwMDAwMDAw
MDAwMDEwMDggClsgMTI4OC40ODg2OTBdIHgzIDogMDAwMDAwMDAwMDAwMTAwOCB4MiA6IDAwMDAw
MDAwMDAwMDEwMDggClsgMTI4OC40ODg4NjldIHgxIDogMDAwMDAwMDAwMDAwMDAwMSB4MCA6IGZm
ZmY4MDAwN2JhODM4YTAgClsgMTI4OC40ODkxODddIApbIDEyODguNDg5MzUwXSBQcm9jZXNzIGt3
b3JrZXIvdTI6MSAocGlkOiAxNiwgc3RhY2sgbGltaXQgPSAweGZmZmY4MDAwN2M0ZGMwMDApClsg
MTI4OC40ODk2NDZdIFN0YWNrOiAoMHhmZmZmODAwMDdjNGRmYTUwIHRvIDB4ZmZmZjgwMDA3YzRl
MDAwMCkKWyAxMjg4LjQ4OTg4MV0gZmE0MDogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGZmZmY4MDAwN2M0ZGZhYzAgZmZmZjAwMDAwODM1MjVkOApbIDEyODguNDkwMTM0XSBmYTYw
OiBmZmZmODAwMDdjNGRmYjM4IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDFmMCBmZmZm
ODAwMDdiYTg1OWYwClsgMTI4OC40OTAzMjldIGZhODA6IGZmZmY4MDAwN2JhYmU5MDAgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmODAwMDdiNDVhZGM4IGZmZmYwMDAwMDhjZWMwMDAKWyAxMjg4LjQ5MDU0
OF0gZmFhMDogZmZmZjgwMDA3YjQ1YWQ5OCAwMDAwMDAwMDAwMDAwMjAwIGZmZmY4MDAwN2M0ZGZi
MzggMDAwMDAwMDEwMDAwMDAwMQpbIDEyODguNDkwNzY0XSBmYWMwOiBmZmZmODAwMDdjNGRmYjAw
IGZmZmYwMDAwMDgwYjk3NzQgMDAwMDAwMDAwMDAwMDAwYSBmZmZmODAwMDdiYTg1YWU4ClsgMTI4
OC40OTA5NjJdIGZhZTA6IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjgwMDA3YmE4NTlmMCBmZmZmODAw
MDdiYWJlOTAwIGZmZmYwMDAwMDgwYjk3NjQKWyAxMjg4LjQ5MTE1NV0gZmIwMDogZmZmZjgwMDA3
YzRkZmJkMCBmZmZmMDAwMDA4MzkxODQwIGZmZmY4MDAwN2JhODM4ODAgZmZmZjgwMDA3YmFiZWE4
MApbIDEyODguNDkxMzcyXSBmYjIwOiAwMDAwMDAwMDAwMDAwMDA4IGZmZmY4MDAwN2I0NWFkMDAg
ZmZmZjgwMDA3YzRkZmI2MCAwMDAwMDAwMGZmZmZmZmM4ClsgMTI4OC40OTE1ODZdIGZiNDA6IGZm
ZmY4MDAwN2JhY2FiODAgZmZmZjgwMDA3YzRkZmJhMCBmZmZmODAwMDdiYWNhYjgwIGZmZmY4MDAw
N2JhODM4ODAKWyAxMjg4LjQ5MTc5OF0gZmI2MDogZmZmZjgwMDA3YjQ1YWU5MCAwMDAwMDAwMDAw
MDAwMDEwIGZmZmY4MDAwN2JhODM4YTAgMDAwMDAwMDAwMDAwMDAwMQpbIDEyODguNDkxOTkxXSBm
YjgwOiAwMDAwMDAwMDAwMDAwMjAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMTAwMCAw
MDAwMDAwMDAwMDAwMDAwClsgMTI4OC40OTIxODNdIGZiYTA6IGZmZmY4MDAwN2JhY2FiODAgZmZm
ZjgwMDA3YjQ1YWU4MCBmZmZmODAwMDdiNDVhZTgwIGZmZmY4MDAyMDAwMDAwMTAKWyAxMjg4LjQ5
MjM5NF0gZmJjMDogMDAwMDAwMTAwMDAwMDAxMCBmZmZmODAwMDAwMDAwMDA3IGZmZmY4MDAwN2M0
ZGZiZjAgZmZmZjAwMDAwODc5NjljNApbIDEyODguNDkyNjA5XSBmYmUwOiBmZmZmODAwMDdiNDVh
ZDgwIGZmZmY4MDAwN2JhODM4MDAgZmZmZjgwMDA3YzRkZmM3MCBmZmZmMDAwMDA4Nzk2Njg4Clsg
MTI4OC40OTI4MzZdIGZjMDA6IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjgwMDA3YjQ1YWQwMCAwMDAw
MDAwMDAwMDAxMDAwIGZmZmZmZmZmZmZmZmZmZjgKWyAxMjg4LjQ5MzAyMF0gZmMyMDogZmZmZjgw
MDA3YjQ1YWM3OCBmZmZmODAwMDdiNDVhYzMwIGZmZmY4MDAwN2I0NWFlNjAgMDAwMDAwMDAwMDAw
MTAwMApbIDEyODguNDkzMjEzXSBmYzQwOiAwMDAwMDAwMDAwMDAwMDAxIDAwMDAwMDAwMDAwMDAw
MDEgZmZmZjAwMDAwOTM3M2Y3NSBmZmZmODAwMDdiNDVhZGE4ClsgMTI4OC40OTM0ODJdIGZjNjA6
IDAwMDAwMDAwMDAwMDAwMDEgMDAwMDAyMDAwMDAwMDAwMCBmZmZmODAwMDdjNGRmZDIwIGZmZmYw
MDAwMDg3OTc0ODAKWyAxMjg4LjQ5NTkyOF0gZmM4MDogZmZmZjgwMDA3YmE4M2YwMCBmZmZmODAw
MDdiNDVhYzMwIGZmZmY4MDAwN2I0NWFjMTAgZmZmZjgwMDA3YzQwODAwMApbIDEyODguNDk2Mzcw
XSBmY2EwOiAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4MDAwN2I0NWFjMTAgZmZmZjAwMDAwOTJhN2Vk
YiBmZmZmODAwMDdiNDVhYzAwClsgMTI4OC40OTY3NjJdIGZjYzA6IGZmZmY4MDAwN2M0MDgwNzgg
ZmZmZjgwMDA3YzQwODJhOCAwMDAwMDAwMDAwMDAwMDAxIGZmZmY4MDAwN2JhMDk4MDAKWyAxMjg4
LjQ5NzE4Ml0gZmNlMDogZmZmZjAwMDAwOTI0YjAwMCBmZmZmMDAwMDA4MGU2ZTEwIGZmZmY4MDAw
N2M0ZGZkODAgZmZmZjAwMDAwMDAwMTAwMApbIDEyODguNDk3NTkwXSBmZDAwOiBmZmZmODAwMDdl
ZmRmODAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjAwMDAwMDAwMDAwMSBmZmZmODAwMDdiNDVhZTgw
ClsgMTI4OC40OTgwMTRdIGZkMjA6IGZmZmY4MDAwN2M0ZGZkYzAgZmZmZjAwMDAwODBkOWQ5NCAw
MDAwMDAwMDAwMDAwMDIwIGZmZmY4MDAwN2M0YzU4MDAKWyAxMjg4LjQ5ODQxMl0gZmQ0MDogZmZm
ZjgwMDA3YmE3ZGQwMCBmZmZmODAwMDdjNDA4MDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjgwMDA3
YjQ1YWMxMApbIDEyODguNDk4Nzg3XSBmZDYwOiBmZmZmMDAwMDA5MmE3ZWRiIGZmZmY4MDAwN2M0
MDgwMjAgZmZmZjgwMDA3YzQwODA3OCBmZmZmODAwMDdjNDA4MmE4ClsgMTI4OC40OTkxNDddIGZk
ODA6IGZmZmY4MDAwN2M0ZGZkZTAgZmZmZjAwMDAwODk3MTgwMCBmZmZmODAwMDdjNGFiZTgwIGZm
ZmY4MDAwN2M0MDgwMDAKWyAxMjg4LjQ5OTM3M10gZmRhMDogZmZmZjgwMDA3YzRjNTgzMCBmZmZm
ODAwMDdjNDA4MDIwIGZmZmYwMDAwMDkyODcwMDAgZmZmZjgwMDA3YjQ1YWMzMApbIDEyODguNDk5
NTcxXSBmZGMwOiBmZmZmODAwMDdjNGRmZTAwIGZmZmYwMDAwMDgwZDlmODAgZmZmZjgwMDA3YzRj
NTgwMCBmZmZmODAwMDdjNDA4MDAwClsgMTI4OC40OTk3NjZdIGZkZTA6IGZmZmY4MDAwN2M0YzU4
MzAgZmZmZjgwMDA3YzQwODAyMCBmZmZmMDAwMDA5Mjg3MDAwIGZmZmY4MDAwN2M0YWJlODAKWyAx
Mjg4LjQ5OTk2M10gZmUwMDogZmZmZjgwMDA3YzRkZmU2MCBmZmZmMDAwMDA4MGRmZTMwIGZmZmY4
MDAwN2M0YzNiMDAgZmZmZjgwMDA3YzRjMzY4MApbIDEyODguNTAwMTU5XSBmZTIwOiBmZmZmMDAw
MDA5MzhmYjA4IGZmZmY4MDAwN2M0YWJlODAgZmZmZjAwMDAwOGM1MDU3MCBmZmZmODAwMDdjNGM1
ODAwClsgMTI4OC41MDAzNzNdIGZlNDA6IGZmZmYwMDAwMDgwZDlmMzggZmZmZjgwMDA3YzRjM2Iz
OCBmZmZmODAwMDdjNDg3ZDIwIDAwMDAwMDAwMDAwMDAwMDAKWyAxMjg4LjUwMDU2OV0gZmU2MDog
MDAwMDAwMDAwMDAwMDAwMCBmZmZmMDAwMDA4MDgyZWMwIGZmZmYwMDAwMDgwZGZkNDAgZmZmZjgw
MDA3YzRjMzY4MApbIDEyODguNTAwNzc3XSBmZTgwOiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAw
MDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgMTI4OC41MDA5NzVd
IGZlYTA6IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAw
IDAwMDAwMDAwMDAwMDAwMDAKWyAxMjg4LjUwMTIwNF0gZmVjMDogMDAwMDAwMDAwMDAwMDAwMCAw
MDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMApbIDEyODgu
NTAxNDAxXSBmZWUwOiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgMTI4OC41MDE2MjFdIGZmMDA6IDAwMDAwMDAwMDAw
MDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAK
WyAxMjg4LjUwMTg3OV0gZmYyMDogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMApbIDEyODguNTAyMTE1XSBmZjQwOiAwMDAw
MDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAw
MDAwMDAwClsgMTI4OC41MDIzMjldIGZmNjA6IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAw
MDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAxMjg4LjUwMjUzMF0gZmY4
MDogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMDAwMApbIDEyODguNTAyNzQyXSBmZmEwOiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAw
MDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgMTI4OC41MDI5
OTZdIGZmYzA6IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwNSAwMDAwMDAwMDAwMDAw
MDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAxMjg4LjUwMzMwNF0gZmZlMDogMDAwMDAwMDAwMDAwMDAw
MCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMApbIDEy
ODguNTAzNzYxXSBDYWxsIHRyYWNlOgpbIDEyODguNTA0Mjc0XSBFeGNlcHRpb24gc3RhY2soMHhm
ZmZmODAwMDdjNGRmODgwIHRvIDB4ZmZmZjgwMDA3YzRkZjliMCkKWyAxMjg4LjUwNDU3Ml0gZjg4
MDogZmZmZjgwMDA3YzRhYmU4MCAwMDAxMDAwMDAwMDAwMDAwIGZmZmY4MDAwN2M0ZGZhNTAgZmZm
ZjAwMDAwODM0ZjQ2YwpbIDEyODguNTA0NzcxXSBmOGEwOiBmZmZmODAwMDdjNGRmOGQwIGZmZmYw
MDAwMDgwZjQxMGMgZmZmZjgwMDA3YmEwOTgwMCBmZmZmODAwMDdlZmRmOGUwClsgMTI4OC41MDQ5
NjhdIGY4YzA6IGZmZmY4MDAwN2M0ZGY4ZDAgZmZmZjAwMDAwODBmNDEyNCBmZmZmODAwMDdjNGRm
OGUwIGZmZmYwMDAwMDgzY2ExODgKWyAxMjg4LjUwNTIzOV0gZjhlMDogZmZmZjgwMDA3YzRkZjk2
MCBmZmZmMDAwMDA4M2NjZTgwIGZmZmYwMDAwMDkzOTUzNzUgZmZmZjAwMDAwODllNTUxMApbIDEy
ODguNTA1NDM5XSBmOTAwOiAwMDAwMDAwMDAwMDAwMDIwIDAwMDAwMDAwMDAwMDAzZTAgMDAwMDAw
MDBmZmZmZmZmOCBmZmZmMDAwMDA5Mzk1MzI4ClsgMTI4OC41MDU2OTNdIGY5MjA6IGZmZmY4MDAw
N2JhODM4YTAgMDAwMDAwMDAwMDAwMDAwMSAwMDAwMDAwMDAwMDAxMDA4IDAwMDAwMDAwMDAwMDEw
MDgKWyAxMjg4LjUwNTg3OF0gZjk0MDogMDAwMDAwMDAwMDAwMTAwOCBmZmZmODAwMDdiYTg1YjY4
IGZmZmY4MDAwMDAwNDAyMDEgMDAwMDAwMDAwMDAwMDAwMQpbIDEyODguNTA2MTUwXSBmOTYwOiAw
MDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDIwMCAwMDAwMDAw
MDAwMDAwMDEwClsgMTI4OC41MDY0NTVdIGY5ODA6IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDEw
MDAwMDAwMCBmZmZmODAwMDdiYWI3Yzg4IGZmZmZmZmZmZmZmZmZmZmYKWyAxMjg4LjUwNzIwMV0g
ZjlhMDogZmZmZjAwMDAwODFlYzY3OCAwMDAwMDAwMDAwNGIzNzY4ClsgMTI4OC41MDc0NjZdIFs8
ZmZmZjAwMDAwODM0ZjQ2Yz5dIHNjYXR0ZXJ3YWxrX2NvcHljaHVua3MrMHgxNDQvMHgxZTgKWyAx
Mjg4LjUwNzYyN10gWzxmZmZmMDAwMDA4MzUyNWQ4Pl0gc2tjaXBoZXJfd2Fsa19kb25lKzB4MjUw
LzB4MmIwClsgMTI4OC41MDc3ODFdIFs8ZmZmZjAwMDAwODBiOTc3ND5dIHh0c19kZWNyeXB0KzB4
ODQvMHhiMApbIDEyODguNTA3OTEzXSBbPGZmZmYwMDAwMDgzOTE4NDA+XSBzaW1kX3NrY2lwaGVy
X2RlY3J5cHQrMHg3MC8weGE4ClsgMTI4OC41MDgwODhdIFs8ZmZmZjAwMDAwODc5NjljND5dIGdl
bml2X2RlY3J5cHQrMHgxYjQvMHgzMjAKWyAxMjg4LjUwODIyNl0gWzxmZmZmMDAwMDA4Nzk2Njg4
Pl0gY3J5cHRfY29udmVydF9iaW8rMHg3OTAvMHg3ZTAKWyAxMjg4LjUwODM2OF0gWzxmZmZmMDAw
MDA4Nzk3NDgwPl0ga2NyeXB0ZF9jcnlwdCsweDJmMC8weDM1OApbIDEyODguNTA4NTA0XSBbPGZm
ZmYwMDAwMDgwZDlkOTQ+XSBwcm9jZXNzX29uZV93b3JrKzB4MWJjLzB4MzYwClsgMTI4OC41MDg2
NDZdIFs8ZmZmZjAwMDAwODBkOWY4MD5dIHdvcmtlcl90aHJlYWQrMHg0OC8weDQ4MApbIDEyODgu
NTA4Nzc4XSBbPGZmZmYwMDAwMDgwZGZlMzA+XSBrdGhyZWFkKzB4ZjAvMHgxMjAKWyAxMjg4LjUw
ODkwNV0gWzxmZmZmMDAwMDA4MDgyZWMwPl0gcmV0X2Zyb21fZm9yaysweDEwLzB4NTAKWyAxMjg4
LjUwOTE1NF0gQ29kZTogZDM0YzdjNDIgZjk0MDAwMDMgOTI3ZWY0NjMgOGIwMjE4NjIgKGY5NDAx
MDQ0KSAKWyAxMjg4LjUwOTc1Nl0gLS0tWyBlbmQgdHJhY2UgOGRlMTVhYjkxZjE2NDU4YSBdLS0t
ClsgMTI4OC41MDk5NTFdIG5vdGU6IGt3b3JrZXIvdTI6MVsxNl0gZXhpdGVkIHdpdGggcHJlZW1w
dF9jb3VudCAxCgo=
--001a113f2784aecc1805465ff935--
