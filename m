Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C6672634;
	Thu, 15 May 2025 18:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747334744; cv=none; b=Q3kycxBbd/C+KyuoHgxPd8UhKvyPdlfYutpTVtPFMrUm/mW/ZzyT9Z9odtzWEwZebWwXITtQtWxEzSg7o1sZngMsmNnG0jS1WMb+Shf1XdO0H2dnwjVcZFhdtpaOVzn81rhGmgh/GlOa/7C8BM2yKP/G7EWvVRmRt8AOag9+Exs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747334744; c=relaxed/simple;
	bh=9WLPjYbuxgmzbErUtY6qGPN4XcL2duXSQLLSfRAPlUw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dMg2rhec4tD80AYABGJ+e5Q8NEEt9XOMAk0QJ2BsB+q7bodU0iDb3+Pe4J2Y9EDbNGklHTUekqXROCpDmO3pwQqI8fD6Z9usLfVoMdqeyWYYHuxiey0KVuWXHIOUe+GDid1sAeaXUppsq3vuWb8DjW3JIIEwvvdNgYe87F63+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O57ymiMe; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O57ymiMe"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so10609535e9.1;
        Thu, 15 May 2025 11:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747334741; x=1747939541; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zv2KEzheJ/MgPqhI9h8gaX+s/CUBTIKXLdES3z3s/l4=;
        b=O57ymiMeiE6HS066ewK85PzeQ73TgIZwn4raa289cMAty3Cx4LeDYv7aoDQFxgzKoX
         f+gF67aTVqrLsBFgrQRhEKdAA5HDFojlCemEQp7EHVRPMOrKpjPbBUK90DE4VgxIZz62
         yRq76yaMcutrXtIxE1AiyqfeHlfFblZTrllsA4hD3Vyrir25S3b8vA2OF2gXCLypePaU
         drNdsRjwJ+MemKRos8m2v7u/71u/h7Sz2RlZObGJ/hMutf0M3aiTvQlq+BPjyIG4yUCM
         JdT5UgQxw6qf3pDeoy8aHAICIAtTmRiCJI6N9y8tzCEWuUmivwWTCDGS97zPPMV4NAei
         ZEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747334741; x=1747939541;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zv2KEzheJ/MgPqhI9h8gaX+s/CUBTIKXLdES3z3s/l4=;
        b=G77abOOAFnk5CfJczrwSSztXoNZIs+pfoISuyn07tn09ZaOV7Nm2LtzrCxcAcO/En0
         TpA3kCZswNM84AZAKPsRZ9NWlpTCql1Y7KMqJA84pIOaZP2532PKKWV3JvkuvwTduY3/
         0rJmt2bdI29+xkZBxGMZVzy51WD1LtH3bD6MLk7uvPAezCF4bMnQM7FLqOGqXh3yvuCL
         +2XfmoOSnLzc/kWXfMQz7SBkXF3tahUAHn8VrmAiVq8205f9gB9QaTLZN+3lwS3uNPrW
         dWcVWXZ1YLRL/vrq6vN6ZKoYqQQLp3/nIQg3r3ZGWEAMP/SEKLWZ1mF7wBlS6J1MEP4d
         bkuw==
X-Forwarded-Encrypted: i=1; AJvYcCVv2c5tSiP4gzFMYRo3pk6zNv9y/VoPJaUXLh2e/H0jmuKsQHP4JmqDCXRajJgtdEgDX7Vo3TBWQLrUSdcV@vger.kernel.org, AJvYcCW/JbxQOSALSAN5u+E4L6A+tHle8IxBM8Qq8ll4oa90EhCb+zTm2kWu7vjjhwYgVRNH0B4LB4YO91F018Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI13k3ibCoa3boKSWVirVQ49FggSWGR/4gnX2j1gFtZQ0bzJP7
	Lt2rXbUSnGgraf6OjzNO0osTPXRXYT+9HHU0ZmTec4FkvYIncZBBg3oq
X-Gm-Gg: ASbGncudxCyXlWEoRZ3whnPagz8/Yq0/RiCH+fTv8BAoItdCRML5OzCZ/1aQF5U6Ci4
	fzF9qzT6dPH+E9baSnngyh0s+j7B7VSoMVOGUXZafC+QH7IR16RO25SaQcaKLMmJ9C/PwDAgjV3
	+DIA45zo0PiTssmL+1F/MxRXsc05yqwBbcskrm0NOBBYYP/TdNSNG+FEVt/tOuhyLk65lpscW5E
	vcRdor13K4WkkzJFfJtkQUT4or6ryVF4iIaGhokcZ3rlvDR9XChokhPxEqUUfa2O/kQ/h2t1/DF
	EyyzbbbAV0CMzphC5wjpsdAjQYR7awhYK1SwMypMTOBVAdi0Nv7mN/eydoSJr1428gLXJbRHtTf
	fweZu2XWBFbDWBryptX8VBQ==
X-Google-Smtp-Source: AGHT+IGEjWzR/1RM405yibigh6lwHJWxY2UWukv1Rc4Eh4xTQ4c5CammOK7/eC3cazBKUYuuzn3TMw==
X-Received: by 2002:a05:600c:c0d2:20b0:43c:f597:d589 with SMTP id 5b1f17b1804b1-442fda2e7d3mr1968665e9.27.1747334740835;
        Thu, 15 May 2025 11:45:40 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:9394:f453:aba3:b8c4? ([2a02:168:6806:0:9394:f453:aba3:b8c4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442fd59701dsm5147505e9.35.2025.05.15.11.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 11:45:40 -0700 (PDT)
Message-ID: <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
 	linux-kernel@vger.kernel.org, Linux Crypto Mailing List	
 <linux-crypto@vger.kernel.org>, Boris Brezillon <bbrezillon@kernel.org>, 
 EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>, Romain Perier
 <romain.perier@gmail.com>
Date: Thu, 15 May 2025 20:45:39 +0200
In-Reply-To: <20250515182131.GC1411@quark>
References: <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
	 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
	 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
	 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
	 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
	 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
	 <aCMOyWVte4tw85_F@gondor.apana.org.au>
	 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
	 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
	 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
	 <20250515182131.GC1411@quark>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-05-15 at 11:21 -0700, Eric Biggers wrote:
>=20
> CRYPTO_SELFTESTS now enables the full set of crypto self-tests, which for=
 the
> past 6 years have been needed to be run anyway to properly validate the d=
rivers;
> just developers often forgot to enable them because they were under a sep=
arate
> kconfig option that had a confusing name.=C2=A0 So the longer test time i=
s expected.
> It's unfortunate that it takes 2 minutes on the platform you're testing (=
on most
> platforms it's much faster), but presumably that is still okay since it's=
 just a
> development option?=C2=A0 People shouldn't be expecting to run these test=
s in
> production kernels.=C2=A0 (But even if they are for some reason, the test=
 time also
> remains configurable via kernel command-line options.)
>=20
> - Eric

Probably it was only the massive amount of printk's which slowed the system=
 down.

With the plain cryptodev tree I now see:

# modprobe marvell-cesa
# dmesg | tail
[    4.949108] mv88e6085 f1072004.mdio-mii:10 lan4: Link is Up - 1Gbps/Full=
 - flow control rx/tx
[    4.949199] br0: port 2(lan4) entered blocking state
[    4.949210] br0: port 2(lan4) entered forwarding state
[   46.915547] marvell-cesa f1090000.crypto: CESA device successfully regis=
tered
[   47.077931] alg: skcipher: skipping comparison tests for mv-cbc-des3-ede=
 because cbc(des3_ede-generic) is unavailable
[   47.096665] alg: skcipher: skipping comparison tests for mv-cbc-aes beca=
use cbc(aes-generic) is unavailable
[   47.103401] alg: skcipher: skipping comparison tests for mv-cbc-des beca=
use cbc(des-generic) is unavailable
[   47.121374] alg: skcipher: skipping comparison tests for mv-ecb-des beca=
use ecb(des-generic) is unavailable
[   47.133757] alg: skcipher: skipping comparison tests for mv-ecb-des3-ede=
 because ecb(des3_ede-generic) is unavailable
[   47.138474] alg: skcipher: skipping comparison tests for mv-ecb-aes beca=
use ecb(aes-generic) is unavailable
# grep test /proc/crypto=20
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed
selftest     : passed

...and the failing marvell-cesa self-tests seem to have magically disappear=
ed.
I now had five successful reboot / modprobe marvell-cesa in a row.

Best regards, Klaus
