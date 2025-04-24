Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1BC21858E;
	Thu, 24 Apr 2025 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745527155; cv=none; b=lp5FFl3FVYyWqqsBu4OeTbUSNNmqDBujb6QiCASo+lnpfiYYRr0XC8ncypP4uwxTzMONJhoTj1FfjsrSGiIrWbb6KuHMDn6qtmc10xP4NGBELfYhRjt5wBZe9/toMk4EN4oA/C3RTX4CZuEIa5cHLOCWxbh7KrWEFF50NSIox8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745527155; c=relaxed/simple;
	bh=nQ3Mzb7NWRMTNOmlLbpDQ1R5Ala77p/VWpIAROQn9Sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JEQmNInLCItlOJt6lGIJFdeOmqQFu8JjsA2r2k87n/epAk+4drUPsht5RaJ24xmJNKZolO9S+SxTPwEzvw9RnODffzHUR8RLpVWjEX/e24jhmRC9yyCrsrtk/rLghTNq24rZXBL3XAGcRcOG0rkqBmQAONAuN/JMFo3Czk/nx2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C0+vlke7; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0+vlke7"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso8818535e9.3;
        Thu, 24 Apr 2025 13:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745527152; x=1746131952; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r/D/PH0rUFFrYhqeW74Gp1hY0bf9Umd1t66r00ZISm4=;
        b=C0+vlke7qA3s0HTeg0S+XhFJr1UOSEeAsRDOtv4ca1+Vk4on6EzdvvrOO8R4WpNFRi
         nuI5hoRVZI3hITPtRuVM073tmjezl13GnZtgPPGzSN1YrDcZ8cajt0RKDypapCWc5Zcz
         53P+NCv6u4jlw54gPE958GA/BVcmDWNk6CnsTdI05G4EIDZhOvqYDu3n0hi4D5yWX7QV
         ZlXe2CLmAwTlYIRuTVfNHscEpkV4rbQAsjs95pLo4tBgmlDfXM16EtLAm+Jrw/kqN4Jr
         kXdChwR6SP3h25QBp+kJ75J64rAL7IqlUBg+/1sCsn3jkNI9R7VpL5beW2uwXQQyi/zJ
         J0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745527152; x=1746131952;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/D/PH0rUFFrYhqeW74Gp1hY0bf9Umd1t66r00ZISm4=;
        b=OTcl9PVAeIM1JF02AszpZl7rPCgpbPtJGjrdt9hWva5QtuaHf42c1xdkkKYizB1E8a
         4BEwKieUiJZpquObz4zDbj6TLDudCFbfrriIOwGaP3bM+BQm8A5IA5lsJ3mNcMeuEqxF
         oylxwZxZiVGsDAjch9YkRfrp/T6beELDeFmrPJ9lr2ZMFyndZO+y2tu0kQyBfqYaRRJU
         AFkRCmY+mTS1zOq37erEeMqg3u3RotKiM4ItEXI5iWlS03Ot8SYr+NALqPpMH7FR3+Tr
         qtjIFu+k1Xh4F0xL1c+/pGZAkenNCX0wrWub9kaV6BSS5HAFtJv4TkJ6pncf5EoyLJLf
         x4EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdSuZhBxUczXrwCEbjoDud/P5iFgfUDTAdfqBjCA98lk9j3xISfz2cr1cwx35ujaAY5SyZKmFgCD1wJn4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTEieXTu4+mmzP8awylLARcjJPuN6MxddDYA+ng//1wd8+Lvdt
	cEda4AVx0Zd2newmFH29/wv/6v44SYq2xfM3zi4ccQytNav9hrlj
X-Gm-Gg: ASbGnctMD9unfC3+tMXP4lq45woyKh2n3qVnky7fhwyYCXIMQm2UiLsltCfvT8BKYE2
	cS/n0RNAPCfyCyAC+p6K74iwHKV2ftUY/gnot4kkn1DtMrj0BCjAinRxL/U4RFgazXoH9XNOS08
	C7jmUC7AMHEtmr8kJdgtSDOWMKGBfYJQiz/1DFzt62u13EVbCq3xdtX6gmgvMt1rnwuulVAB8/x
	AgwtytSZvjKGlRW2573dizkjSehscPa/ez2jpv+ruEYe6KOI6SnLalxaM8B4qK9yPuKKIFTquXA
	PGIrvVePwiqQ39ZzKrHhyBacodaZRUbie6/0KhavZA==
X-Google-Smtp-Source: AGHT+IG+6KKZSu15xf0leSuksMynDxPCWVzAORsheH70mD8f61JVwVtDr0F6+30YIXrEJALffEigAw==
X-Received: by 2002:a05:6000:1acb:b0:39c:1258:2dc9 with SMTP id ffacd0b85a97d-3a06cfc8283mr3557246f8f.58.1745527151654;
        Thu, 24 Apr 2025 13:39:11 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a073cc4025sm320188f8f.56.2025.04.24.13.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 13:39:11 -0700 (PDT)
Date: Thu, 24 Apr 2025 22:39:09 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Remove CRYPTO_ALG_ENGINE bit
Message-ID: <aAqhbdiLmkHV350S@Red>
References: <aAop_uMhxVh2l5Fy@Red>
 <aApN64n7i15ArnX4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aApN64n7i15ArnX4@gondor.apana.org.au>

Le Thu, Apr 24, 2025 at 10:42:51PM +0800, Herbert Xu a écrit :
> On Thu, Apr 24, 2025 at 02:09:34PM +0200, Corentin Labbe wrote:
> > 
> > Example on x86_64:
> > [    4.637589] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > [    4.637822] #PF: supervisor instruction fetch in kernel mode
> > [    4.637931] #PF: error_code(0x0010) - not-present page
> > [    4.638166] PGD 0 P4D 0 
> > [    4.638359] Oops: Oops: 0010 [#1] SMP NOPTI
> > [    4.638808] CPU: 0 UID: 0 PID: 64 Comm: virtio1-engine Not tainted 6.15.0-rc1-g63dc06cd12f9 #1 PREEMPT(voluntary) 
> 
> This patch should fix the crypto_engine failures:
> 
> ---8<---
> Remove the private and obsolete CRYPTO_ALG_ENGINE bit which is
> conflicting with the new CRYPTO_ALG_DUP_FIRST bit.
> 
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Thanks it fixes my crypto hw devices.
So Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>

But I still got some crash with blake2b:
+[   54.348477] alg: shash: blake2b-256-neon test failed (wrong result) on test vector 1, cfg="init+update+final aligned buffer"
+[   54.348525] alg: self-tests for blake2b-256 using blake2b-256-neon failed (rc=-22)
+[   54.348536] ------------[ cut here ]------------
+[   54.348545] WARNING: CPU: 1 PID: 909 at crypto/testmgr.c:5871 alg_test+0x644/0x654
+[   54.348575] alg: self-tests for blake2b-256 using blake2b-256-neon failed (rc=-22)
+[   54.348583] Modules linked in: blake2b_neon(+) blake2b_generic rmd160 xxhash_generic ccm gcm crypto_null ghash_generic ghash_arm_ce camellia_generic fcrypt pcbc anubis wp512 khazad tea michael_mic arc4 libarc4 cast6_generic cast5_generic cast_common xctr serpent_generic lrw gf128mul twofish_generic twofish_common blowfish_generic blowfish_common md4 md5 tcrypt(+) cfg80211 bluetooth ecdh_generic ecc ctr sun8i_drm_hdmi uas des_generic libdes sun4i_codec snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm snd_timer snd lima drm_shmem_helper dw_hdmi gpu_sched aes_arm_bs aes_arm soundcore sunxi musb_hdrc sun4i_drm sun4i_frontend sun4i_tcon sun8i_mixer sun8i_ce sun8i_tcon_top drm_dma_helper display_connector
+[   54.348927] CPU: 1 UID: 0 PID: 909 Comm: cryptomgr_test Not tainted 6.15.0-rc1-g0ba1b8bdf183 #22 NONE 
+[   54.348941] Hardware name: Allwinner sun8i Family
+[   54.348947] Call trace: 
+[   54.348961]  unwind_backtrace from show_stack+0x10/0x14
+[   54.348989]  show_stack from dump_stack_lvl+0x54/0x68
+[   54.349010]  dump_stack_lvl from __warn+0x7c/0x128
+[   54.349035]  __warn from warn_slowpath_fmt+0x124/0x18c
+[   54.349059]  warn_slowpath_fmt from alg_test+0x644/0x654
+[   54.349081]  alg_test from cryptomgr_test+0x18/0x38
+[   54.349097]  cryptomgr_test from kthread+0x10c/0x238
+[   54.349121]  kthread from ret_from_fork+0x14/0x28
+[   54.349140] Exception stack(0xf0aa9fb0 to 0xf0aa9ff8)
+[   54.349151] 9fa0:                                     00000000 00000000 00000000 00000000
+[   54.349162] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
+[   54.349171] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
+[   54.349177] ---[ end trace 0000000000000000 ]---

Regards
