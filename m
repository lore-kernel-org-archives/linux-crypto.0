Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF939E17A
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770125737; cv=none; b=gvoNUpuF7kexkTF6KkYu7gRX5sOj6JoJdmQwe0sOV01OBFrhFoHOB3iPFADej1jLq2NDXr82VC+e5BJ11NCSM0Xt5dJHwzqzg2X6+uK4or1ygJQrz2ObxLM13x2ltDir7rkQK/q9VH/4reTgO8TyvFIH/Z1O9y3AYwLSIfLJN1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770125737; c=relaxed/simple;
	bh=io/EYxv7ttfZ5c/LLL9VvcayFvS43ID701JLwnZ6lKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SisCsMvxDHK+a6XgWytXd8EjpbZdIO9ladUmZgkFXKAi76Fno2C6IWAIuUTV4oN8sQbMqF6aBQl4n08avoBQJYmDrYnpglUMLJd+5SuX/HCGqtBLt3gOJh9k+WjjYWwkh7DkGyN9Wn73slHiC3zamOScy/JThL5S6psZ+TSt8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OV5RnKFK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lpWbaqrA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OV5RnKFK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lpWbaqrA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770125731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4BpfLzNQISMcvb3bYUowH+LAX7zmYdRcPREXRs4s810=;
	b=OV5RnKFKxLl6l30u+PB+khFQUn67EBfB1wFm7iL1WWnnW4918OKNa970Yt5wwi2/0xdFK3
	Wfdp2VLPHTQJB74AE/8xETajlbYwhW4Q2vAOJBQc5fZ92cuy1cTHlD0ccPZkOdLq4oKzuL
	kX3GaZ/tlX81hFhZCHKIXJ7ngCB3d+4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-FeT5cu71NO62jOc_6ajd1Q-1; Tue, 03 Feb 2026 08:35:29 -0500
X-MC-Unique: FeT5cu71NO62jOc_6ajd1Q-1
X-Mimecast-MFC-AGG-ID: FeT5cu71NO62jOc_6ajd1Q_1770125729
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0bae9acd4so41112455ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Feb 2026 05:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770125727; x=1770730527; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4BpfLzNQISMcvb3bYUowH+LAX7zmYdRcPREXRs4s810=;
        b=lpWbaqrAqaJRaYbc1ybv2Ucqx11nF82dGvFMj7aQe26XVyKS63ImwXTt4yQV1OJOFd
         zbbXFnkA5Vqj0qWehdKuJmpfE4USQVqU8ZV04xjSn7cFiZCpXyCQ0zYz2OfruEB8qJzY
         g87DlfrReDJG30Ebwdxxuk4Xi86yk3nd8BbfvSyXwqtrYfnzO0Q8caI2UhhBMck45Kns
         2B/Q4bHmS6YjEq+wM/veOSeEGnAMgQjGtRkl92YVR1cJ4N3REhoWxfifgpA5YK8uA8Ae
         hxgeLtRgOd413PM6jOKRx16nuhuAYPkYkJ7ct3sQ/+FpECiROxL4UkLUiuMrk6WijCjN
         z/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770125727; x=1770730527;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4BpfLzNQISMcvb3bYUowH+LAX7zmYdRcPREXRs4s810=;
        b=rDyPvkqTbNFz3UqWaKzyfbdyC0GDpQ+rSlhk2pD0pSXfY525t8+sqrH6sAc3WJKOKa
         bOPvKBMQtG75krHm2MRkxqLk8U2mUXH3iV0KnvUsU+rPCgI23PIuXm8wdZOScUx7knAZ
         82VAtqI8FJoYlPM6MMhpH09RxF4liNvZYVaplg7UToM6P6qEUGp9iUekVD2Eiv+mar3s
         Ny0zZmtUEUNZ8d87wE0969d5nhgKjJV0urr5P3ZNauaWYJPJqALSHlh53SKQKQastuM7
         CDKapVFw5DSzou74vtasfRF1x1zADw32QdviWYw7YIzog7PrzIoZDdApo/cGePqMt8YA
         lcJw==
X-Forwarded-Encrypted: i=1; AJvYcCUHj8sHEQYiBN6IvnZi6z/bxa7YKp4lIvRGSg7YcDCHLE863g5GRnyedLWHhHNHBimWcjpskYs3qLeMIRc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdDYHF+8cDE3Ih/txJCwrxpb71FnNhd+6d9/nftMk7mAYXcHZp
	tjcIgoO2f7ATWbVejl9YwvkuYCHrEviXb6/TSiKPAhzMVTB46bvZDRff51A93Z6+4Wa1pfb15sh
	/qlKY85KEfIvL+3N2PBCwwaEQ6RpfPwL4R3eWwdKTXWVGO9dpnAAZrBBYT906JQr5vR3rYnS66u
	BKnLw=
X-Gm-Gg: AZuq6aLc+GyJwue/mqTWztnmeafW6R50YLyQPJTNpt7X0iBSqj+Ey1jyfGq6NB5u5nA
	R9o+kja/b2QBr+vAs+XBHQ7gsCQe86z7JtgUDgwFAkCByicEMYra+oKaXaSUCZ69oN5syDw5dQn
	+hCggBDCyahLjtv8hPNEAbqRC2Q3J6IOkuIbbQIaW9H4KMnJ12eao4hZLcVYRSgIVDLr6TOyojL
	ebdl5pLqXXALwSmrZMNQE1UblfPhTi6zgspd1WNuqC0Yk/A0IGwHD/PVFLNjZ1fwWQUEaydSLRe
	uuQgONJ+wWM7X+l+I3OUGGBsv7P5a/pFCQzGjfnbI0cld+OQZgdEHyoUWnI2LGyKh9DdnVR9i7O
	X
X-Received: by 2002:a17:902:e891:b0:2a0:d662:7285 with SMTP id d9443c01a7336-2a8d8945522mr156161665ad.0.1770125727231;
        Tue, 03 Feb 2026 05:35:27 -0800 (PST)
X-Received: by 2002:a17:902:e891:b0:2a0:d662:7285 with SMTP id d9443c01a7336-2a8d8945522mr156161175ad.0.1770125726520;
        Tue, 03 Feb 2026 05:35:26 -0800 (PST)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3df6sm177027765ad.49.2026.02.03.05.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 05:35:25 -0800 (PST)
Date: Tue, 3 Feb 2026 21:32:44 +0800
From: Coiby Xu <coxu@redhat.com>
To: Johannes =?utf-8?B?V2llc2LDtmNr?= <johannes.wiesboeck@aisec.fraunhofer.de>
Cc: dhowells@redhat.com, dmitry.kasatkin@gmail.com, ebiggers@kernel.org, 
	eric.snowberg@oracle.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org, 
	roberto.sassu@huawei.com, simo@redhat.com, zohar@linux.ibm.com, 
	michael.weiss@aisec.fraunhofer.de
Subject: Re: IMA and PQC
Message-ID: <aYHznG6vbptVOjHQ@Rk>
References: <aXrKaTem9nnWNuGV@Rk>
 <20260130203126.662082-1-johannes.wiesboeck@aisec.fraunhofer.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260130203126.662082-1-johannes.wiesboeck@aisec.fraunhofer.de>

On Fri, Jan 30, 2026 at 09:31:26PM +0100, Johannes Wiesböck wrote:
>Hi all,

Hi Johannes,

>
>we conducted an evaluation regarding PQC use in IMA last year (see [1] for all
>details) where we also considered the interplay of different PQC signatures and
>file systems (ext4, btrfs, XFS, f2fs).

Thanks for sharing this comprehensive study! There are many nuances in
this research paper!

>
>Coiby Xu <coxu@redhat.com> wrote:
>
>>According to my experiments done so far, for verification speed,
>>ML-DSA-65 is consistently faster than ECDSA P-384 which is used by
>>current CentOS/RHEL to sign files in a package.
>
>Regarding performance, similar to Coiby, we found that all variants of ML-DSA
>consistently outperformed ECDSA P-256.

Glad to know ML-DSA is also faster than ECDSA P-256!

>
>>The size of a single ML-DSA-65 signature indeed increases dramatically
>>compared with ECDSA P-384 (3309 bytes vs ~100 bytes). But I'm not sure
>>it can be a big problem when considering the storage capacity. Take
>>latest fresh CentOS Stream 10 x86_64 KVM guest as example, without any
>>file system optimization, extra ~189MB disk space is needed if all files
>>in /usr signed using by ML-DSA-65 where the disk size is 50G. But I
>>don't have enough experience to tell how users will perceive it and I'll
>>try to collect more feedback.
>>
>>For the details of my experiments, you can check
>>https://gist.github.com/coiby/41cf3a4d59cd64fb19d35b9ac42e4cd7
>>And here's the tldr; version,
>>- Verification Speed: ML-DSA-65 is consistently ~10-12% faster
>>   at verification than ECDSA P-384 when verifying all files in /usr;
>>   ML-DSA-65 is 2.5x or 3x faster by "openssl speed"
>>
>>- Signing Speed: ML-DSA-65 appears ~25-30% slower when signing
>>   all files in /usr; ML-DSA-65 is 4x or 4.8x slower by "openssl speed"
>>
>>- Storage overhead: For ML-DSA-65, /usr will increase by 189MB and
>>   430MB when there are 27346 and 58341 files respectively. But total
>>   size of pure IMA signatures are estimated (files x (3309+20) bytes) to
>>   be ~87MB and ~185MB respectively.
>
>Two relevant aspects we discovered regard the signature size. TL;DR:
>
>1. Most file systems need to be tuned to support the larger extended attributes
>(signatures) if their size goes above a certain threshold (e.g. enable EA_INODE
>in ext4). This influences not only disk usage but overall compatibility between
>file systems and PQC signatures. A file system that would not provide the
>functionality to store larger extended attributes would be incompatible with
>large signatures.
>
>2. For most smaller signatures (like ML-DSA-44/65), we believe that the overhead
>of signatures is actually compensated by fragmentation within the file systems.
>For example, ext4 will allocate a full file system block for extended attributes.
>As long as the signature size is below this block size, we did not observe less
>free space on the file system despite the larger signatures.

I think this explains why I didn't see any disk overhead when using ECDSA P-384:)

>
>Overall, we concluded that ML-DSA-65 provides the best combination of disk
>overhead, performance and security level. Performace was good and for all
>algorithms with larger signatures than ML-DSA-65, file systems would need to be
>tuned.

Thanks for summarizing your findings regarding the signature size and
also sharing your evaluation!

>
>>According to
>>https://www.ietf.org/archive/id/draft-salter-lamps-cms-ml-dsa-00.html
>>ML-DSA-44 is intended to meet NIST's level 2 security category. Will
>>NIST level 2 meet users' security requirements?
>
>Regarding security levels:
>For security levels, we referred to NIST IR 8547 ipd [2].
>ECDSA P-256 has a classical security strength of 128bits (P-384: 192bits).
>According to [2] Table 3, these levels are met by the different ML-DSA variants.
>So, if you are migrating from ECDSA P-384, you need to use at least ML-DSA-65 to
>meet the same security strength.

This is helpful info! And thanks for sharing the perspective of
migration!

>
>Best regards,
>Johannes
>
>[1] https://www.wsbck.net/publications/pqc-ima.pdf
>[2] https://nvlpubs.nist.gov/nistpubs/ir/2024/NIST.IR.8547.ipd.pdf
>

-- 
Best regards,
Coiby

