From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: RSA/MPI handling issues and keyctl access to public key keyrings
Date: Mon, 9 May 2016 15:56:27 -0700
Message-ID: <268bb9cd-08ca-aae9-5b12-91d8c0195bc1@intel.com>
References: <7781.1462785198@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>,
	"Zaborowski, Andrew" <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbcEIW5Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 18:57:25 -0400
In-Reply-To: <7781.1462785198@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,
On 05/09/2016 02:13 AM, David Howells wrote:
> Hi Tadeusz, Andrzej,
> 
> If you look here:
> 
>         http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git
> 
> you will see a branch labelled 'pkey'.  This, so far, provides query support
> through keyctl:
> 
>         [root@andromeda ~]# openssl x509 -inform PEM -outform DER \
>             <~/pkcs7/firmwarekey2.x509 | keyctl padd asymmetric "" @s
>         805557749
>         [root@andromeda ~]# keyctl pkey_query 805557749 - enc=pkcs1 hash=sha256
>         INFO: enc=pkcs1 hash=sha256
>         key_size=4104
>         max_data_size=513
>         max_sig_size=513
>         max_enc_size=513
>         max_dec_size=513
>         encrypt=n
>         decrypt=n
>         sign=n
>         verify=y
> 
> and verification support:
> 
>         [root@andromeda ~]# keyctl pkey_verify $k - data sig enc=pkcs1 hash=sha1
>         [root@andromeda ~]# keyctl pkey_verify $k - data sig enc=pkcs1 hash=sha256
>         keyctl_pkey_verify: Bad message
>         [root@andromeda ~]# keyctl pkey_verify $k - data sig enc=raw
>         keyctl_pkey_verify: Key was rejected by service
> 
> You need:
> 
>         http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl
> 
> to add the kernel support.
> 
> I noticed some potential issues whilst I was getting this to work:

Thanks for your comments.

> 
>  (1) In mpi_write_to_sgl(), this snippet:
> 
>         if (*nbytes < n - lzeros) {
>                 *nbytes = n - lzeros;
>                 return -EOVERFLOW;
>         }
> 
>      is potentially mixing signed and unsigned data in a comparison which
>      could lead to some interesting effects.

Both nbytes and n are unsigned. The n - lzeros will never be less than zero
because we can't have more zeros in a than the size of a.
We should be safe here.

> 
>  (2) rsa-pkcs1pad needs to indicate what the maximum content size is, given
>      the minimum possible padding for the specified hash type (ie. a
>      particular OID).

The user needs to use crypto_akcipher_maxsize(tfm) to get the required buffer
size for a given key.
We do check if the buffer if big enough to accommodate padding and hash info.
This is needed in sign and encrypt operations, and in both cases we check it,
sign:
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n434
and encrypt:
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n252

> 
>  (3) In pkcs1pad_verify():
> 
>         /* Reuse input buffer, output to a new buffer */
>         req_ctx->child_req.src = req->src;
>         req_ctx->child_req.src_len = req->src_len;
>         req_ctx->child_req.dst = req_ctx->out_sg;
>         req_ctx->child_req.dst_len = ctx->key_size - 1;
> 
>      Reuses the output buffer without validating the new size - I'm not sure
>      whether this is checked elsewhere, but if someone gives you a smaller
>      buffer than you need, you might overrun.

Only the src is reused for the actual operation and the destination is allocated
just below:
	req_ctx->out_buf = kmalloc(ctx->key_size,
			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
			GFP_KERNEL : GFP_ATOMIC);

then in pkcs1pad_verify_complete() we do check if the original buffer is big enough:

	if (req->dst_len < req_ctx->child_req.dst_len - pos)
		err = -EOVERFLOW;

> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
TS
