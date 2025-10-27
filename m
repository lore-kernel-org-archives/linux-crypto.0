Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDB22EE60F
	for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 08:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761554552; cv=none; b=LhJ+tlF10S7UIxi4b858IhlyPVHkkuKXFuvLQz7F/p5+M4zU4U8ZE09iCEyW9cpZtlpDECD4qZD5K5XZImfGltD7iR5ZCnjJkRWZzIfLMt2JfA+1DPirljtnG0nlKGX+cc2d+D+5Bpd8tXp/Ks/rfwii/6VSj0451gzCXVj9Lfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761554552; c=relaxed/simple;
	bh=UG8pE67BLGZgv3QifxWbYYEqvT3PKB5usDKrFSSOST8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4BJfC8oQM2DxJRbqPYLBPZ8C1OfGLrGR8xEW4FPqGvjGCsaL4N/YSnH9V4Cix2JHfkMRZL7/Z23YD83SxhMF5EiVUJGiutHWNXJglf2EP8g1feYvSV2j+x1EtuEuTp1MPLn47bkNXWzK/wSt7qVO9aJUvtS3B6y95HikaC50IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bh7j9kBF; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bh7j9kBF"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b6d3340dc2aso1014020966b.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 01:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761554549; x=1762159349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFlBtrits7DNlZ6h+mgbiMIVvWdiVqZSUXzsme0rVO8=;
        b=Bh7j9kBFU1CekGtkw8gUdc6g4MwHmMZziwIOcuJR6f393+1syomtldv/ri0gdo75qo
         CLZz4aNDjBZuK6NhDNOevGVN5naelzt/GG0D5f2NGqcJx4Y9Cf/TjX4cC4Up/PT2/55z
         gf7vAitFMDtEjr7FDLlTmzm6qYsEzLZ5tNuyO3qiKPfe3z1dxrFDJ2YpZFZSiP3gItVT
         2qR0YO4NR59xVacMBK27K7kH/ipyUY1oOpZ4M1OS/UB0c4uvE05fy6FChIjA6pJlK+Ve
         A0PK+MQP6ha0nXImmmd7oYDUZRXQt2q5OuPGOSIP08Ycmg7gya5we6gYQHWWypBuNxY6
         S8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761554549; x=1762159349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iFlBtrits7DNlZ6h+mgbiMIVvWdiVqZSUXzsme0rVO8=;
        b=pjIHg1QEEI8ozupSan9tfmKW/ydH3AupQ+RNDwOMgfHNFUHYv1a2lprNs2ULgjI9cH
         abvVal0lxMA3VEKN0xqbyDrVF4YGuNuc8EyJQEBM1gAYRkSHc1a7qQTd/b/Bg/1IW5Mb
         TMFmy2bjVEtQyJkEuPDt5gRhc0kUk06cE/6lan8KIpRrBOUZNLTuK7p6bR0rPnXUUZER
         3UxpS521MjOIfctMATuso4itR+Tf+wE+0HrL/6MSt5UQZXagQJy3idZA9eUW6++v507u
         oyS0UVFfmwE0LilqZ9bl0UZMwt2Usb2Kf59qlkXO79JfUJRNLx6L9LaF+3+1ALtI/7i2
         KY6A==
X-Forwarded-Encrypted: i=1; AJvYcCVr/TkL76axtcBdOZdSckmIiZtA1IVAd2sX2Ij6lrVqFAkRKc1Wv7QcOuskdp2/I3dLnGehRqKuCZlKx80=@vger.kernel.org
X-Gm-Message-State: AOJu0YxExvG1fS20+sp72H+m3ubDPb5jD5jnvScGuxtEa1xJcufrhRw7
	UWFcJds5bggGiDCrIFm5M193hbzgcEzmyYxaU1RKe3RtJMAP/L8/TMtz
X-Gm-Gg: ASbGnct7FLIfh7KBQFYt30pUdQUsFhu4p/FTg1SKqnAYN3jyXro691FxTjsjnARkX6H
	cr37pHjaOZ9dsDtvCvwTg7a3pDiRo14H0LBtW612SyZY6D5L0Bk6Bos//H0ER7mMduCofH188h5
	4syZ8K4REsJ9H4rdYQkgr/niquuZORwGnd3lSjobCscxZvXl2uyVCmDv7NJaOAyQyaef+mjjggT
	L12EPRs06xCtYh2P44Fr1xlOMJeoAE0QK5JlzBJA04L4l77AwWm2w0ZFSguBcBDsHqgHHIT+Iet
	rLrsA3KFw57L2LXVmAxWP4ssXfQUFhfqVYgdsksmZLsb9aBsr/Kkmmdqgm0khPIwpLgTgQZls5A
	YKyZQPXIj0NqHIvT8fpDg+Z6uL94EECVy7wbTpKgpacJrnftMFIia7kt3gcoyUsZnfHywhj8qai
	K+
X-Google-Smtp-Source: AGHT+IHNDWdV6nOLEUPb8BsKdy1fTa79zHhvllKqWIEzW+JrO9Bj5NMu8vYte0D/T+VD4YYNH0vo+A==
X-Received: by 2002:a17:907:1c85:b0:b64:6cc7:6ac7 with SMTP id a640c23a62f3a-b6d6bb9083emr1215693866b.22.1761554548711;
        Mon, 27 Oct 2025 01:42:28 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b6d853696aesm704277666b.30.2025.10.27.01.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 01:42:28 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH] pm-hibernate: flush block device cache when hibernating
Date: Mon, 27 Oct 2025 11:42:20 +0300
Message-ID: <20251027084220.2064289-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
References: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> Hi
> 
> Does this patch fix it?
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> There was reported failure that hibernation doesn't work with 
> dm-integrity. The reason for the failure is that the hibernation code 
> doesn't issue the FLUSH bio - the data still sits in the dm-integrity 
> cache and they are lost when poweroff happens.

I tested this patch in Qemu on current master (43e9ad0c55a3). Also I
applied Mario's patch
https://lore.kernel.org/linux-pm/20251026033115.436448-1-superm1@kernel.org/ .
It is needed, otherwise you get WARNING when you try to hibernate.

The patch doesn't work.

Here is script I used for reproduction:
https://zerobin.net/?66669be7d2404586#xWufhCq7zCoOk3LJcJCj7W4k3vYT3U4vhGutTN3p8m0= .
It is the same script as in previous letter. I just added some
"integritysetup status /dev/mapper/..." calls.

Here are results:
https://zerobin.net/?2331637d633d20c5#EmyhxiHLDmoZT1jBVbe/q9iJKhDEw4n+Bwr5mAcaOpM= .

File names mean the same as in previous letter, i. e.:

> "log-def-1" is output of first Qemu invocation (i. e. first boot) with
> default integritysetup options. "log-def-2" is second Qemu invocation
> (i. e. when we try to resume).
> 
> log-bit-{1,2} is same thing, but with "--integrity-bitmap-mode" added to
> "integritysetup format" and "integritysetup open".
> 
> log-no-{1,2} is same, but with "--integrity-no-journal".
> 
> log-nodm-{1,2} is same, but without dm-integrity at all, i. e. we create
> swap directly on partition.

Results are somewhat better than without the patch. Without the patch
we don't even try to resume in default mode. "blkid" simply reports
"swap" instead of "swsuspend". With patch "blkid" reports "swsuspend", and
so we try to resume. But then in the middle of resuming we get this:

[    1.008223] PM: Image loading progress:  70%
[    1.017478] PM: Image loading progress:  80%
[    1.027069] PM: Image loading progress:  90%
[    1.029653] PM: hibernation: Read 36196 kbytes in 0.49 seconds (73.86 MB/s)
[    1.030146] PM: Error -1 resuming
[    1.030322] PM: hibernation: Failed to load image, recovering.

(See link above for full logs.)

Very similar thing happens in "--integrity-no-journal" mode in the middle of
resuming:

[    0.531245] device-mapper: integrity: dm-0: Checksum failed at sector 0x6e70
[    0.531600] PM: Error -84 resuming
[    0.531799] PM: hibernation: Failed to load image, recovering.

The patch doesn't change anything in "--integrity-bitmap-mode" mode:
we still are able to resume, but then get integrity errors when we do
"cat /dev/mapper/swap > /dev/null".

-- 
Askar Safin
