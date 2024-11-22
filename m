Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBAC1632DC;
	Fri, 22 Nov 2024 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732257787; cv=none; b=HQc7gtAoGW/Ai6aWUiZX9vD6Q4u4slHOQcdbrNsKyUTIQYBlcUQI9WEoaGXHBmAnlE2fFtbWgMy2ObGuEobSyJLNoKX4h5ohAYpCdF0AcTUTmp8ucAcoZU1qoa5pxYCchbk5fpy49KnSL/ms6QQUhdwoICNauFUH9ZqF2Aw64W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732257787; c=relaxed/simple;
	bh=pPVeIRdsw+cjbZoONd4IcJExIcXvQWAidHNWx09Farg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFRiB00e73cbFoEgoYddHIDGR8xaRZp4lGipCrdbh4ZdeShR7K0hkdULQgwZiffADMXuPZkRjs103cr9ngN7s6d+ap9fCMYiJctn7Huza7dSeLOD8jRTWFVHcNKX4igF8RmG7GE9PqGIlX3wONWmF6Uix82IolETRkOZNMFfXHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMHFqkYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMHFqkYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2CCC4CECE;
	Fri, 22 Nov 2024 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732257786;
	bh=pPVeIRdsw+cjbZoONd4IcJExIcXvQWAidHNWx09Farg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lMHFqkYFyxq6EtTNZq+6yaHWeqE2296YK5w3CfryKOYNIdmg+F8FnAoOaDOmH+xxk
	 lYvW6x9zBgbomfWLFEcLC5A07nfBj3fVzurs6hcz9HpJHVO8sk8+GrNMfuc8Yl6L0F
	 XwaRSaqugr2xoBtX8auhP0EOBNVNKIVazGnWRQGqAmjhUTQ/FpMCGeLY1SI27LmwaF
	 uNsauxRlGTUHSyay7CkWOmrJJX7cY4FrDBZ6DiqPpRshwM55iViLnUPDUyYarbe9Nr
	 oz8H5fklewCliSl7tYFReDqi/Xe0RZkNDQjkAbpQ3xRejp4ESplMmnjmteCX5VFeGa
	 FJiYTevqOtylQ==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539e8607c2aso1948993e87.3;
        Thu, 21 Nov 2024 22:43:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWyFbbIRzEdmqE6rnsyNMwrzVIVksNirga4uixWQ81ZgfdTdccl8B8pPBWZh3h5oh5/BUwMIVYQQPqez+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSFwtqRTY2pD3/jwJoPkAsVJPCC7BHaOX/cQ7JAff2VGjt9jKW
	XQmfPN2xzXoIvBdf7zpte9mxyLiW8iPHLdcBMmE2cAk4dIOzei1J808BUFMyjTsbTHnHVNka8r+
	h1CMm9SVABrgXzhJHR0sCtAWChfM=
X-Google-Smtp-Source: AGHT+IEZWa5ieH0Zuzv3oYICEkGpeEhHrre9AFb4UPBUadqbngvzxptEPjBajRge5GZCVY6QGK53EY3ePCPJHZwgYX4=
X-Received: by 2002:a05:6512:1152:b0:53d:d461:80df with SMTP id
 2adb3069b0e04-53dd461831fmr379627e87.25.1732257784872; Thu, 21 Nov 2024
 22:43:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 22 Nov 2024 07:42:54 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
Message-ID: <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
To: Zorro Lang <zlang@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 05:51, Zorro Lang <zlang@redhat.com> wrote:
>
> Hi,
>
> I hit a kernel panic on aarch64 several times recently, when I tried to do a
> fstests test. It's not related with fstests, due to I hit it when I boot the
> latest mainline linux kernel (HEAD=fc39fb56917bb3cb53e99560ca3612a84456ada2).
>
> The console log looks like related with crypto things, I'm not familar with
> it, so just send this email to linux-crypto@ and cc linux-kernel@.
>
> I hit this panic several times, I did nothing except building and installing
> the latest kernel and then boot it, then it crash directly on booting time.
> Looks like crash from:
>
>        183 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>        184                               unsigned int buflen)
>        185 {
>        186 #ifdef CONFIG_DEBUG_SG
> ==>    187         BUG_ON(!virt_addr_valid(buf));
>        188 #endif
>        189         sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
>        190 }
>
> If someone need, I can provide the big linux/.config file.
>

Does this help?

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4300,12 +4300,14 @@

 static int test_sig_one(struct crypto_sig *tfm, const struct sig_testvec *vecs)
 {
+       const u8 *src __free(kfree);
        u8 *ptr, *key __free(kfree);
        int err, sig_size;

+       src = kmemdup_nul(vecs->c, vecs->c_size, GFP_KERNEL);
        key = kmalloc(vecs->key_len + 2 * sizeof(u32) + vecs->param_len,
                      GFP_KERNEL);
-       if (!key)
+       if (!src || !key)
                return -ENOMEM;

        /* ecrdsa expects additional parameters appended to the key */
@@ -4326,7 +4328,7 @@
         * Run asymmetric signature verification first
         * (which does not require a private key)
         */
-       err = crypto_sig_verify(tfm, vecs->c, vecs->c_size,
+       err = crypto_sig_verify(tfm, src, vecs->c_size,
                                vecs->m, vecs->m_size);
        if (err) {
                pr_err("alg: sig: verify test failed: err %d\n", err);
