Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0117B50A
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 10:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149706; cv=none; b=WRz8wl2Z2xxiJe2Qti9faUQBXAS7m3BwS3KI1SBivamCzz1W0PJH1untu+5dEv5vcYc1x63jBWOpkJQCA6+e1AJDHeALSG5xWLwxZ1id6BAkPSvdy4MIwYzjtvdOD0hfsfhIcHSdjQqNyEdRpzt9nUqcEiWifkEblCBEERsMee0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149706; c=relaxed/simple;
	bh=S/Eh9hBo2L1p8PM9VoPGiASMmWIYDRK37k4O3WL7zBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OK78LMGANQPSoTp5qLqSL1H26pHDVxXpITCSQdC4CVZMTXru3Uwvn0fRYQoUZwdi6kKjAj3GiA7/BXEdMFeJA3Xi5Ul3XBArH9l9mkafYlN7Wi/fnpmdpBZMhPD5ZIBAUjFQtxcrDsRisI2h6yq0k7QOdnij4aiMK+eYyavOToU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=ODSQxL0J; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="ODSQxL0J"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47de0093c42so1980683f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 03:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1785149700; x=1785754500; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F/LJwxBo8S2WUPh2JQ0yvhQ63PUPluEcft3s0nqaThU=;
        b=ODSQxL0Jtyqdjm4na2LtGluvf7ct4AUpPqCh4NssZYcJsYKBs4b5N05yqtpdHjPlGC
         ND65EwUq3cjLHygYnhDSV2OcpoVSJC6vmyfvOV+QfdX1C6UoTkrzBtSWFn8hKU5RDo/E
         LzmcV7MZUFMZZ4kBkSStkrerOIxOgGdxpmP1V4rjWKW2lEclrg6+r/Mn16J8RSnM+pEW
         ID5X6qNAUe/RDT26W6MeWcnFIRZG97jAq6ZOpT4M81f3VHxuEsMibN6D6dzUUEhGDn/K
         ZhSp1KfZDhp6JKZTZLYF6b/stfIKICGPF+oyxMwEUq8SQIchZUsl8BcZwtW5xJvDNF5w
         TKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149700; x=1785754500;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F/LJwxBo8S2WUPh2JQ0yvhQ63PUPluEcft3s0nqaThU=;
        b=PTCumy9BytTYb507KpcJEMgfS2ybjHhSRaouMheW7WZSDM6d8N7XL7Kbfm1cQ3H5/m
         z3wwngX4NztPJzWlAY8n5xWtFaYxuMdxoeAfk8zUOIL5NKw1/JkSWkgmE8I4iid3GyMi
         bWzIHf50EMtO/fFNZWN2vl+wbjc8aYPUGZNUMZMphHO7peQ8IzHmWk+0yWiOmmS9jJHK
         /4yPw8bVcYqVdKuF9W+LDVJDnNWSPGErQ/zVbTUqK8bcEC9QINfyjXNqBrmn8sT6zOP7
         H1wmBRlHW1v1beJ4jaQsXYBVqqI9o00utCtjzoy7Lij19hDXAE83ysr0CDqzgJ3JA0zE
         zIwQ==
X-Forwarded-Encrypted: i=1; AHgh+Roz7wabNU3KFs3XrQSS2vC/twlQE3V90bzY70AFIqa4ByUnjNfUyWinAt/eNr2bdgFg2FxJzuSC8HGyhC0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2iQZ1HNfcIrs5ReaBHfvWhVRZvm1pXTmSkX2dVvSdIqKVzXi6
	6unm4ticDiNUh7WlHwntnY7V6XM6QwQnemVkyS5+vLggR9fCSBC/5gg+q/GopHDfjmk=
X-Gm-Gg: AR+sD12H7MIa+BeZhj3Wdvza7vrfkTbfTFzceML3Xm3caJpq2zlR3o4TaJWodWET9GS
	yLlsN7w8Z6GkzKoG/w8ykAo10VLq/lDtjpv1lOT43vl4G6RjysBajcC3+AMj6eOfLyIRuyTMKxs
	SJi5JMN4sQCv2X/zqjfaW4s1LudINQutUsYLgXuHIV61P3F6pOBuwBAmQOPGW2fmq8T0uZ+QzUw
	7KKlSCR3gGcoCPF/8Imve7eN8sY5+GM7z+Tj0Hm0ZkVyUnL1FlCTlrVHz1jKXEelw0XVkblap6v
	1uAbeH5AMfvHH5gAclRcfsSL1hgd1fDrk/73dNLujmBn/YmZ/Wo409I/jWWznPaoEllR0PvME7n
	p4DQWDeptyGu/rBI97zeKmXJsY7p0kJ12HffbQKh0xidEldH47dIKSw0XUL9IN6TnDkAqfevELI
	kVK/w=
X-Received: by 2002:a05:6000:2585:b0:47f:9503:a300 with SMTP id ffacd0b85a97d-47f9fc8d092mr10286453f8f.4.1785149700356;
        Mon, 27 Jul 2026 03:55:00 -0700 (PDT)
Received: from somecomputer ([82.150.214.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531afsm52352457f8f.24.2026.07.27.03.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:55:00 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Milan Broz <gmazyland@gmail.com>, Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: AF_ALG deprecation fallout
Date: Mon, 27 Jul 2026 12:54:59 +0200
Message-ID: <4366518.b9uPGUboIS@nailgun>
In-Reply-To: <20260726153736.GA1673@sol>
References:
 <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <4065668.hXSD6JRtRq@nailgun> <20260726153736.GA1673@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Sonntag, 26. Juli 2026 17:37 Eric Biggers wrote:
> > cryptsetup's --with-crypto_backend=kernel helps a lot here.
> > So, by completely removing AF_ALG these systems would unnecessarily
> > suffer. Please keep both AF_ALG and --with-crypto_backend=kernel around.
> 
> I assume the key on these systems tends not to come from user input
> (such as a passphrase).  So do you know why cryptsetup and LUKS is being
> used at all, instead of just using dm-crypt directly?

LUKS is not only about passphrases, you can also pass key files.

It's also convenient to store other meta data in the LUKS header,
especially in combination with a TPM chip.
We commonly use the same format as systemd-cryptenroll does.

Having LUKS has also the benefit of having a clear indication whether the key
is correct or not.
In contrast to a mount failure where the super block contains garbage.
 
> Even if LUKS is used, it should be feasible to implement with neither
> AF_ALG nor an external userspace crypto library, saving space over your
> requested solution which bloats the kernel with AF_ALG.  Indeed, in
> cryptsetup, LUKS keyslot en/decryption already falls back to a temporary
> dm-crypt mapping; see lib/utils_storage_wrappers.c.  I understand this
> wasn't done consistently in old versions, but in v2.8.7 it is.
> 
> For key derivation, assuming the LUKS2 defaults are used, cryptsetup
> already has built-in Argon2 code, including an implementation of the
> BLAKE2b hash function; see lib/crypto_backend/argon2/blake2/.
> 
> So it seems the only missing piece for LUKS is actually the metadata
> checksums.  (I'll assume that 'cryptsetup benchmark' and support for
> formatting a file in LUKS format as non-root users aren't needed here;
> those seem to be for testing purposes.)  For LUKS2 that's SHA-256.
> Built-in SHA-256 could be added to cryptsetup; this would be much
> smaller than the code for AF_ALG.  Alternatively, for new volumes,
> support for configuring these to use BLAKE2b could be added, simply
> reusing the BLAKE2b code that is already built-in for key derivation...
> 
> So it seems quite feasible.  But I strongly suspect that direct use of
> dm-crypt would be a better solution for these systems, which would
> eliminate the need for cryptsetup entirely.

If cryptsetup can offer itself everything to open a LUKS volume without the need
of an external crypto library, I'm more than happy.

My main goal is avoiding disasters after a kernel upgrade.
We at $dayjob we help to maintain systems with support times of 20 years and more,
kernels are regularly upgraded. So, regressions do hurt.

Thanks,
//richard


