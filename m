From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH] virtio-crypto: adjust priority of algorithm
Date: Fri, 13 Jan 2017 09:24:43 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA18FD9A@DGGEMA505-MBX.china.huawei.com>
References: <1484288741-31100-1-git-send-email-arei.gonglei@huawei.com>
	<874ee338-4dd6-8a2c-fb95-59bd784de026@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"mst@redhat.com" <mst@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <874ee338-4dd6-8a2c-fb95-59bd784de026@de.ibm.com>
Content-Language: zh-CN
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

>
> From: Christian Borntraeger [mailto:borntraeger@de.ibm.com]
> Sent: Friday, January 13, 2017 4:28 PM
> To: Gonglei (Arei); virtualization@lists.linux-foundation.org;
> linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: mst@redhat.com; herbert@gondor.apana.org.au
> Subject: Re: [PATCH] virtio-crypto: adjust priority of algorithm
> 
> ACK. Whoever takes this patch might want to fixup 3 typos.
> 
Thanks, I'd better send v2 IMHO.  :)

Regards,
-Gonglei

> On 01/13/2017 07:25 AM, Gonglei wrote:
> 
> > Some hardware accelerators (like intel aseni or the s390
> 					aesni
> > cpacf functions) have lower priorities than virtio
> > crypto, and those drivers are faster than the same in
> > the host via virtio. So let's lower the priority of
> > virtio-crypto's algorithm, make it's higher than sofeware
>                                                    software
> > implimentations but lower than the hardware ones.
>   implementations
> >
> > Suggested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> > ---
> >  drivers/crypto/virtio/virtio_crypto_algs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c
> b/drivers/crypto/virtio/virtio_crypto_algs.c
> > index 6f40a42..4de4740 100644
> > --- a/drivers/crypto/virtio/virtio_crypto_algs.c
> > +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> > @@ -498,7 +498,7 @@ void virtio_crypto_ablkcipher_finalize_req(
> >  static struct crypto_alg virtio_crypto_algs[] = { {
> >  	.cra_name = "cbc(aes)",
> >  	.cra_driver_name = "virtio_crypto_aes_cbc",
> > -	.cra_priority = 501,
> > +	.cra_priority = 150,
> >  	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> >  	.cra_blocksize = AES_BLOCK_SIZE,
> >  	.cra_ctxsize  = sizeof(struct virtio_crypto_ablkcipher_ctx),
> >
