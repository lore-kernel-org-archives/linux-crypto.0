Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CEB663
	for <linux-crypto@vger.kernel.org>; Mon,  1 Sep 2025 06:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756707625; cv=none; b=N9p2EnNc3YkECRCgyDKUYRQwv4b3YDBDV1vJ/SYY/mziT6X5NHX6ewXMBKe0eXhDcYedMjTUdBVL4b3zfVXZYAA7WoSKIOc80UMkf1a3e4qORL3Tkl3z0YIWVusY9SQ5VXDVNKewmAuOTuVFXFwdEPUlTtVwtNCwfbPNPi2a9nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756707625; c=relaxed/simple;
	bh=zEw56TQKLGr0Y3WkeD2bIN2naB4CJkL1H9Om+s3CJuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NIoyYW28bpe8F8jMm6HwJQXdkOX19HMlZbKEU+zlBjEl4y2xJbgWM2Jgz+xDDh5OrVDmEAXI5RvdnMYOhoTu2wBD54JwXomKP4ZDlU31khWEqh6zHJzH+Me6J7jdlXEPBGbGEgl2mluFl45+AuhwQLIKhNUuio9Yw/pUhcqeC1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRX/91zB; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRX/91zB"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3cf991e8bb8so1557981f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 31 Aug 2025 23:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756707622; x=1757312422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QxCqpsdXk+aJA7X9N6VWwefDW8+28K76YuJxIrwtnCk=;
        b=NRX/91zB6X08cFPu/rqeQWL1mQ6Iuss2mFNnrvCwGVKzS5ezxRhbA8ArkZywT/kKpW
         dE/995Ah9zZvu9u9WE8WmwtqqbnuHaruNmEknA3trhRaa574EiQvYWD9gn6Ro9M5Dkjt
         ESfjie9s52ni1O488jo2iulF/pC90h1GLpUgtDaRMbxkcRrJDkdxpGb75HCvftm69E0V
         z1rf4zAUbf0fp2hQD5KKyCzhW6yHlB8XXcWNlxq39AssuuCDY65lohhDYcm/YrCZsIKV
         iojZxPXtiW/xZbceqHkV8kCnRw9HAMZlgH7wm0qvEpG5JSTosHxO6Bj9PgXZePtlXqYT
         SiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707622; x=1757312422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QxCqpsdXk+aJA7X9N6VWwefDW8+28K76YuJxIrwtnCk=;
        b=RMI5KErNIrOnSosKvxKj4L238bTbOMNOOuWZ1kgPPU/nT7NMuTWHKJjeYZms5pW+r7
         7i/YQ9DPB+3cXbGg1dT4PixljAAPtjQF4AUecCv/me7Dyeq3tDtcpxyCvhTLUnXmjW1b
         kNNzAXAlLF/KS4E11or46PIM2oWqdd2GDSgO6KeaGTQTZ7kl9xB7qn/AcijNut/i35Cr
         6DMJflQsqfFFVtwu3Afx1U7UM5jVfAcu7yLmqnyqiLb48SXCtJ9mct2WoUD69awCutQ2
         2qgF91Jq333+7z7wprbWgkBRpJMxzBsEF+CZwglxPcab0wbfmDaufp/e2Zcsl23ynXUw
         Pn9A==
X-Gm-Message-State: AOJu0Yx1f9FFtck7wVv9nhNO6ES8KycCn4tqZl38bxv5MY2OUj9G5wyH
	Nc6c/lQyHBiubgGQehm7oKZYXSF7YcEilzTCB9T8B4HYFajC74Z94ZI2
X-Gm-Gg: ASbGncuJbPDQBuztRgg0arWG1DKDU1Y31ByVJOwmgBccdhToDHjLOlKs3rGvY3g+hGD
	7BhY+BeH+ZaSQzcvlscrzDHDMjKBpkGyfy+5g5dpvcbJRTIGhNT5xZyU3Oti2LPWCTZmnmvj3Nc
	JBdpXDEw3OWLp2hgm3bMWzvX15T52fn/XmWBAOddAGg+YWvz1pDLM1yzwkULoTvsQJRh9UE/N02
	v6Kv6WWGRfiV2QjT1/Diq5rftMddqX+BdJLDaIzyGaRfKDPkkfHVmzL98rI6wIt6Zlv9v22xmyo
	zuyBrx4xGKxP41+4tCfs/WWkmA7qZnhMTpuCeRN22th+hv5E45Dy7NLfprKBrbTS1fJX5uPORVl
	Hf0E3dx6sX0HaOuWt2sqV8WMJCbCn34lkGTOyJtA9k6w42V/P1o8PGasN9+YIC3s4Xxk6J76Mkw
	K/76h8
X-Google-Smtp-Source: AGHT+IGzkxP0bB/QY+KUJ3DWQPfE/rzycScZhofPAt1vXBqyoiVSt93G5FecSYBKTnMtcpZyBZv0gQ==
X-Received: by 2002:a05:6000:4203:b0:3c8:7fbf:2d6d with SMTP id ffacd0b85a97d-3d1def61f35mr5082980f8f.50.1756707621679;
        Sun, 31 Aug 2025 23:20:21 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c207:b600:978:f6fa:583e:b091? ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66f2041fsm134998655e9.5.2025.08.31.23.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Aug 2025 23:20:21 -0700 (PDT)
Message-ID: <17bee9ab-7a39-4968-8778-ab2484ff58f7@gmail.com>
Date: Mon, 1 Sep 2025 09:20:20 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IFtCVUddIGNyeXB0bzogc2hhc2gg4oCTIGNyeXB0b19zaGFzaF9l?=
 =?UTF-8?Q?xport=5Fcore=28=29_fails_with_-ENOSYS_after_libcrypto_updates_mer?=
 =?UTF-8?Q?ge?=
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 herbert@gondor.apana.org.au, ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
References: <aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 8/31/25 10:48 PM, Giovanni Cabiddu wrote:
> After commit 13150742b09e ("Merge tag 'libcrypto-updates-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux"),
> crypto_shash_export_core() fails with -ENOSYS for all SHA algorithms
> registered via shash.
> 
> The failure originates from shash_default_export_core(), which is now
> being used as the default export function. However, this function is not
> implemented, resulting in -ENOSYS.
> 
> Before the merge, SHA shash implementations were setting the
> CRYPTO_AHASH_ALG_BLOCK_ONLY flag. This caused alg->export_core to be
> assigned to alg->export, enabling proper state export. It seems the
> removal of CRYPTO_AHASH_ALG_BLOCK_ONLY from the SHA implementations was
> intentional, is this correct?
> 
> This issue breaks all aead implementations in the QAT driver, which
> since commit ccafe2821cfa ("crypto: qat – Use crypto_shash_export_core")
> rely on crypto_shash_export_core() to retrieve the initial state for
> HMAC (i.e., H(K' xor opad) and H(K' xor ipad)).
> 
> It’s likely that the Chelsio driver is also affected, as it uses the
> same API.
> 

It seems that all legacy ahash drivers that set the
CRYPTO_ALG_NEED_FALLBACK flag are also affected.

I tested sha256 with the sun8i-ce driver and since commit e0cd37169103
("crypto: sha256 - Wrap library and add HMAC support"),
crypto_alloc_ahash("sha256-sun8i-ce", 0, 0) calls fail with -ENOSYS.

The issue seems to be that drivers that set the CRYPTO_ALG_NEED_FALLBACK
flag fail to allocate a fallback because now the sha256-lib shash
wrappers are marked as CRYPTO_AHASH_ALG_NO_EXPORT_CORE (because they
lack an import_core()/export_core() implementation), so they can no
longer be used as fallback.

In crypto/ahash.c, crypto_ahash_init_tfm() specifically asks for
fallbacks that do not have the CRYPTO_AHASH_ALG_NO_EXPORT_CORE flag set:

    if (crypto_ahash_need_fallback(hash)) {
        fb = crypto_alloc_ahash(crypto_ahash_alg_name(hash),
                                CRYPTO_ALG_REQ_VIRT,
                                CRYPTO_ALG_ASYNC |
                                CRYPTO_ALG_REQ_VIRT |
                                CRYPTO_AHASH_ALG_NO_EXPORT_CORE);
    ...

The import_core()/export_core() functionality seems to be used by the
ahash Crypto API to support CRYPTO_AHASH_ALG_BLOCK_ONLY drivers (such as
padlock and aspeed drivers, that make use of use
crypto_ahash_import_core()/crypto_ahash_export_core()). Unless it can be
reimplemented to use the software library directly, I think the shash
sha library wrappers need to implement import_core() and export_core()
hooks so that shaX-lib can be used again as fallback.

Thanks,
Ovidiu

> What is the recommended way to move forward?  Should the SHA
> implementations reintroduce CRYPTO_AHASH_ALG_BLOCK_ONLY?  Should
> shash_default_export_core() be properly implemented?  Should drivers
> like QAT switch to using the software library directly to export the SHA
> state?  Or is there another preferred approach?
> 
> Thanks,
> 

