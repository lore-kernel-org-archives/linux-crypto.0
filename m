Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652609;
	b=MfaezM1myLaN2lhhnzLY3Iuw0IPh2hMaVlqe6KYsvPMA1iRUuJuV3J0aVlG85QKHX6fW
	 g45qopQ6ozf6hh56KrDDBaEKZw7J6mzcJwhAUOMER3Fi1IeJ71iDuMgUpZIO971gvmzD4
	 brbQMG4/mZhXNKcq9O7LCC+S9H08X2syShZmcKCcNXOyGMhSdOvKoeluFqe3TmUQxq894
	 X7lzotk6hPApE5INZmeii0I+KAWk77qL9hwXcuaDWnGwLuXj5zQBTY3/NF2aqRJA5Z6m8
	 wCU2YQvlYzSyeuS+lpVpi3Xogqqnxa1/BAhKBLRzv8Hr5IOMQITnxS++Q4OIH50AgDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652609;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YZHqs0S+0eF//NcnMf6waWSJNb6hMzfVqF5rDbvKzzE=;
	b=t4tVvR0mPWzOPlHxLt/lHB7WD1oJl9YW/2D5cud7FkEnz422GfBlSZ2sSDf1HjMUKSsp
	 U5zshHQs5RixkkfgGJWgJO9StJUaS3OLGGkXzAP1aosJbkO0f34GMKejY+M+Cm/rSmLy/
	 CJt4hWGXOMe9Ob0vomHBMnEP0IO/AZMxDxIAOxi8LwLYOD6ngSquYbYQ1DGGb6dOMdsqx
	 z70qvAQSyS0GZL4DBjcoWFx6L6APeafHI0PXOWg+GUYCdYTlD3z1vwK4rMXk8bEAlv3H8
	 yl3S37LxRLlU1Jf4a2QIS2e6o/R/dfc4OcvJGDahUSN7IA5SDTNoYDcPAc7yBzKuZFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21606606A326
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 20:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21606606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c247f6687dcso606002266b.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 12:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652607; x=1794257407;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YZHqs0S+0eF//NcnMf6waWSJNb6hMzfVqF5rDbvKzzE=;
        b=QF73+AzfvewmXZ7kqPeNZxJcKmQiGbNmbDCbyAP5L+oKWUSOA4TJWeHOkm07/6pExg
         XU+vPYNGPDH3M5dUo2J7tWk2wCw31ZZdxUQD+ezcTKyC05sutDALXXaSwz2N0I6Fj7Qb
         6TcZ706bDS8mice+YkwOKq8b8PZA+KShYY9iF0ZYk6uvNIeS6dMceY5BV/oMe+88mJTN
         NyilkOA4LosfulC9vKNnPjwb3hcZo0WBfw4LygF7XDvWywEyvCfNbQXLSKWeD/5C9o/a
         vj2NZjJtrUQeqRhx9w3KPlwWg3NfEwTeuESacxQ+rAIgEy+fV5+h3AFxYq8s/RxdsjzQ
         9KpA==
X-Forwarded-Encrypted: i=1; AKwUvByFjHi4Agyqq2YwGmp+QQdbyN7D3OAidnQNpIWe/Ka3eUs5LPKZiWY0Y9ruDVhOLqCWrEgtxVDRklK/0is=@vger.kernel.org
X-Gm-Message-State: APuU4Z+zfuhAcXBaelDFzZFB8qExvuw6RkDzcCySF69C8zEPW3N6pNsE
	9t/FI2dIMTOMHtb9rzOj5KANLOJxEh6abmtjLgpS+wViW904O3IxTyp2l/JgjYRRSDc=
X-Gm-Gg: AYBFou2uPwjRg9lTZoWSQTo+0h4m42C7FEVLRZlw4TvKlFacP+sdoc8zhAprlmQ8/Xw
	Re8do5s6Cn5SiRuPkdGWzTsMZuT1AVz1nDdsZxkDxQGUfbU6HaTanHfw7l6hqXtYE/MxMsJmmoj
	tnXZS+yWestExbt+xwWsNx1p4q7NHgpV4Yfr+a3m+lMY2O/OW7OE3phEi6gHie23mMSoUoMAxI9
	BB2xDbdWBQPJsM/7xvxvniwDlJyfZdmILiIqlVmzCsc0AVCDeyCzE+ZhCjAsSKJN7tGsVaO9zB/
	Nu6RT86AkIjoiO0L9jTmkgOdAf3Hta46QCPRuP63qLroym8sKlR8rF1zOAi/j6t41LhyDw5+TPh
	hLZBMVQMB8UClkZ91OSn6Ve64prz06ijuNN9zg9x87/V5XnwVdHzz5F4bjiYFvgrqNAY66SySWR
	TVi4ptjIl6+uos3XKiSmQVTLeDwaoI4V5glyhumkuGmCqdhxXWOFA3Oe1c+zrJOW4lt4bmBMezQ
	iC6JLQuFNpq0IbIjx632Ay+1xNVdv15GsK2O3X5IekkDuFnvTf2l+mgukkeR0kxEox0ZOMMHAx8
	JoS/LZ9Ehx979+1mho2jFQ6Zx5wBRKDnqImeejH6YVC05yu7IHPMAloH/zEs9pKFMtXivNP1Y7Z
	iMjiQ
X-Received: by 2002:a17:907:84c:b0:c46:ba0d:3728 with SMTP id a640c23a62f3a-c4ca7a408c7mr910077766b.18.1793652607246;
        Mon, 02 Nov 2026 12:50:07 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cec16d585sm23348966b.81.2026.11.02.12.50.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 12:50:06 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1d8944cb0so5863874a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 12:50:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByz3YQ4gYW28nsQUCP9SxZwPdvyst5r6qwOINc6TxRsU+l1B8UlcUTDqL80GeSnwm/ArWgV7O6h91O1p+g=@vger.kernel.org
X-Received: by 2002:a17:907:930d:b0:c46:9ee5:eeee with SMTP id
 a640c23a62f3a-c4ca79357a1mr947048866b.6.1793652606765; Mon, 02 Nov 2026
 12:50:06 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102074934.2925339-1-gubowen5@huawei.com>
In-Reply-To: <20261102074934.2925339-1-gubowen5@huawei.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Mon, 2 Nov 2026 20:49:55 +0000
X-Gmail-Original-Message-ID: <CAOs+rJWjCTUwuYQMcBcbiUk8K_NQQtYGVFEBDEMZAKHWCLv98A@mail.gmail.com>
X-Gm-Features: AclHuK9uKtGwMBZoHntdWHPm90lnYY-0KuyQanxDFP3TVplvFnPCOByhCba7eNE
Message-ID: <CAOs+rJWjCTUwuYQMcBcbiUk8K_NQQtYGVFEBDEMZAKHWCLv98A@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: asymmetric_keys: verify_pefile: fix integer
 underflow in pefile_strip_sig_wrapper
To: Gu Bowen <gubowen5@huawei.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 7:32=E2=80=AFAM Gu Bowen <gubowen5@huawei.com> wrote=
:

nit: the subject line looks malformed: weird "-next" suffix pointing
nowhere. Otherwise:

> The pefile_strip_sig_wrapper() function validates the win_certificate
> wrapper that precedes the PKCS#7 signature in a PE binary.  It checks
> that the wrapper length does not exceed the certificate table size
> (``wrapper.length > ctx->sig_len``) but fails to verify that the
> wrapper length is at least ``sizeof(struct win_certificate)`` (8 bytes).
>
> When a crafted PE image supplies a wrapper with ``length`` in the range
> [1, 7], the subsequent arithmetic::
>
>     ctx->sig_len =3D wrapper.length;      /* e.g. 1 */
>     ctx->sig_offset +=3D sizeof(wrapper);
>     ctx->sig_len -=3D sizeof(wrapper);    /* 1 - 8 =3D 0xFFFFFFF9 (unsign=
ed) */
>
> underflows the unsigned ``ctx->sig_len`` to a value near UINT_MAX.  The
> following ``sig_len < 4`` sanity check is bypassed because 0xFFFFFFF9 is
> greater than 4.
>
> The underflowed ``sig_len`` is then passed to verify_pkcs7_signature()
> and onwards to asn1_ber_decoder().  The ASN.1 decoder's own
> ``datalen > 65535`` entry guard can be satisfied by constructing a
> PKCS#7 length field of exactly 65535 (e.g. ``30 82 ff fb``), allowing
> the decoder to proceed and attempt to read OID octets beyond the
> allocated vmalloc buffer, triggering a page fault in look_up_OID()::
>
>   BUG: unable to handle page fault for address: ffffd1e986cb2000
>   #PF: supervisor read access in kernel mode
>   RIP: 0010:look_up_OID+0x14/0x100
>   Call Trace:
>    pkcs7_note_OID+0x33/0xa0
>    asn1_ber_decoder+0x363/0xbd0
>    pkcs7_parse_message+0xd9/0x1b0
>    verify_pkcs7_signature+0x24/0x80
>    verify_pefile_signature+0x7b/0xf0
>    kexec_kernel_verify_pe_sig+0x1b/0x40
>    kimage_file_alloc_init+0x1d8/0x3f0
>    __se_sys_kexec_file_load+0xc6/0x270
>
> This is reachable through the kexec_file_load syscall on architectures
> that verify PE signatures (x86 bzImage with
> CONFIG_KEXEC_BZIMAGE_VERIFY_SIG, arm64 Image with
> CONFIG_KEXEC_IMAGE_VERIFY_SIG), requiring CAP_SYS_BOOT.
>
> The oops occurs while the caller holds kexec_lock; if the faulting task
> is killed, the lock is never released, leaving all subsequent kexec and
> kdump operations permanently returning -EBUSY until reboot.
>
> Add a lower-bound check on wrapper.length before the subtraction to
> prevent the underflow.
>
> Fixes: 09dacbbda935 ("pefile: Strip the wrapper off of the cert data bloc=
k")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
>  crypto/asymmetric_keys/verify_pefile.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_k=
eys/verify_pefile.c
> index cec99db14129..cfa85ccb1cf7 100644
> --- a/crypto/asymmetric_keys/verify_pefile.c
> +++ b/crypto/asymmetric_keys/verify_pefile.c
> @@ -146,6 +146,11 @@ static int pefile_strip_sig_wrapper(const void *pebu=
f,
>                         ctx->sig_len, wrapper.length);
>                 return -ELIBBAD;
>         }
> +       if (wrapper.length < sizeof(wrapper)) {
> +               pr_warn("Signature wrapper too small (%x < %zx)\n",
> +                       wrapper.length, sizeof(wrapper));
> +               return -ELIBBAD;
> +       }
>         if (wrapper.revision !=3D WIN_CERT_REVISION_2_0) {
>                 pr_warn("Signature is not revision 2.0\n");
>                 return -ENOTSUPP;
> --
> 2.43.0
>
>
