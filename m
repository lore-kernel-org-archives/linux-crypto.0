Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7633F36606D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769772030; cv=none; b=cMoBUcFzZK75hCG6PTXqB+eEQcffm6cN4YQqxWTdzplwAgg3SWqbYyPA50pdoiY93rHf4R83DQESO4PAZaBS5Iw0ywNVh2plisjV9jupjVZOMYvchmDVFLmDYMTx1iwfkm+PKrVJd/35INIDrz36qqKfYSEEuCZ72QWQhEvPEds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769772030; c=relaxed/simple;
	bh=zdaxgBWHfOjQ1zh3GrG3YLN/+zyFU3lbY6MfKIPUukw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLDkNI0VY7hvG5UyZ+oga2c3q3619Mh5JQ9iOWD30LqB9CbR/sXeHpDAXW/nO37jBkX1O7POGy8Dmxng00AA3pDJwywXQsNOsjE3ZvCRU6y+9wllcgseBhUb4IUHvgeNPJiW07Xn1O2Qexo7wRjEBODIcZMmPZS4cp0xLu+aUM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRvQ2HJK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TOlX2r+l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRvQ2HJK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TOlX2r+l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769772028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qi7R1t4hPvfEKk8VW4gjKJE0vso+HGJ4y2WhvsIHDuc=;
	b=VRvQ2HJK1IbT7QLP28euYCxozgQ/TwfyAGI3KvyhsHguf8jCGEU5OPnWTCLUJVRfCIm1Pc
	FGXqiRJtZwdToE9iULIZtMBjTVTKbUGPPKpqlSMG8IDmVivavTeprTjhx+mmAf8rPagv5D
	SudMFBSsIr+a5SuhrDbooj7trHC2z4M=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-T4dq63eqM_-8cBRmSqBIBA-1; Fri, 30 Jan 2026 06:20:27 -0500
X-MC-Unique: T4dq63eqM_-8cBRmSqBIBA-1
X-Mimecast-MFC-AGG-ID: T4dq63eqM_-8cBRmSqBIBA_1769772026
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a773db3803so23832305ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 03:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769772026; x=1770376826; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qi7R1t4hPvfEKk8VW4gjKJE0vso+HGJ4y2WhvsIHDuc=;
        b=TOlX2r+l305YUCPNU5nTuFbsbGNAzRCRbdczHGrnIRQzV9y8iMAg8KONhHzFWcE8Zq
         98R2GNKoCLJh6GGlaGC+Az62ptbFqkNhmEZWyKvuuWxl8ko/MJglOVlvtC/uymMR7mB6
         WCSdRZL1iKyEPZPDD05dtKbIFNpDXTx14x3BT1PSKQ5cki9xMropIDIU5ntq1ZamJvxe
         Bk26peZnfPiUeWQq5mm3nKIGByadfO0YVbXp9EOGfu/tpVKsgODKXbVsovoEjXNgWy1t
         pdXBD6PBDUoVnrp0rQb3BBnUrLajJvufZaCqGFZTevEee8UBEscoYllpyflT710lv/fe
         T9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769772026; x=1770376826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qi7R1t4hPvfEKk8VW4gjKJE0vso+HGJ4y2WhvsIHDuc=;
        b=mC2bWryRZqXQW8KHFuphFyIDI0m0AGkeD778iYLvAMq/mcMqio6IjCVdX2tfA+Xj8a
         BuTomw9fxf0yIlVUh0TDLUkMvYDuCztVODNdWoFeZDEaRd3Z3devZFvUpLlZH9WZTSpB
         yMM7dpaM9U9e6NBMaFSsbhnWD3DOt3BmNKMNzVzYmSjUvanzO657vMEG/0wdSOapyck8
         aNGH3dQeGf8br6ngYGlPwoxOpupSd0vVrWZhU9fILoazmUx4Gn1EaGbHMnueoBIxbPoq
         Jozo+fLNSbiw3RctrhTxKmt3lSEXHMuz3xYfd+ZU0nw3ZG41ONesB2jdCsGPHcJSHVbX
         8z4g==
X-Forwarded-Encrypted: i=1; AJvYcCWJawdIp27HeOp7pZzrmbf9PPqUWVKRY+xPBAUHGZihJ9DwXWWPP19CeNmk8B+onYlbPqIoQ9Ci83Q8WFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIf/tbdGOWSJNyJB1tJrP2RnRviOR0y2P94IG7nk1Je5b3WB6e
	yYGv0Qv5ixdLp4AUhWU70wk1lEnE8G9FUp51ibhpquBiw9cu+eHAi1cDjboWpgKh1XOoQlHo6tJ
	Ahp4914iXl4EHAk0BsDcU0mnfSFmL4RFKDMjyIu8ChYXRkUIysA61hFetxiEWoN3ekDnrA/ZODA
	cB
X-Gm-Gg: AZuq6aKj67dsPnKLnYg4mOmcRfVCTzo0Wgjd0EOKRELfdiSXsamOef8OtvuDT7sBDPr
	w2DGi+HtFDyy2ZW51tb/v7VOWEaNYcESKGc8gU0471zWBxQhJWLfrRtL4TfZ+PItg2Wlph8NtDG
	OBLAO5XEkOTj0P71jYGPMi7+E5WUSz7anNKU/lBpMyuPiZd2ObBEgWI4C8LUizeV/SVE0FqPH0F
	6BQxTBOYTpgzWcm0A8GnUpGqSs+jXUvpXgOaab4Sm5HwcdylJUOLR88tGtzy6fhsIx58ht+T+nr
	N4gDY8J5ovgedPLoVEVU7JzAZhEM/4T3S3z7idyANLYfxHF85Qeys/PEi4KC3YaxyIBLKEZKFim
	7
X-Received: by 2002:a17:903:b0b:b0:2a0:d46d:f990 with SMTP id d9443c01a7336-2a8d992f0c2mr25748595ad.31.1769772025505;
        Fri, 30 Jan 2026 03:20:25 -0800 (PST)
X-Received: by 2002:a17:903:b0b:b0:2a0:d46d:f990 with SMTP id d9443c01a7336-2a8d992f0c2mr25748205ad.31.1769772024877;
        Fri, 30 Jan 2026 03:20:24 -0800 (PST)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b3eedd0sm72565075ad.3.2026.01.30.03.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 03:20:24 -0800 (PST)
Date: Fri, 30 Jan 2026 19:17:16 +0800
From: Coiby Xu <coxu@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Simo Sorce <simo@redhat.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Eric Biggers <ebiggers@kernel.org>, 
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: IMA and PQC
Message-ID: <aXrKaTem9nnWNuGV@Rk>
References: <1783975.1769190197@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1783975.1769190197@warthog.procyon.org.uk>

Hi David, 

Thanks for starting the discussion on potential issues or challenges for
IMA PQC support!

On Fri, Jan 23, 2026 at 05:43:17PM +0000, David Howells wrote:
>Hi Mimi,
>
>I've posted patches which I hope will accepted to implement ML-DSA module
>signing:
>
>	https://lore.kernel.org/linux-crypto/1753972.1769166821@warthog.procyon.org.uk/T/#t
>
>but for the moment, it will give an error to pkcs7_get_digest() if there's no
>digest available (which there won't be with ML-DSA).  This means that there
>isn't a hash for IMA to get at for TPM measurement.
>
>Now, I probably have to make a SHA256 hash anyway for UEFI blacklisting
>purposes, so that could be used.  Alternatively, we can require the use of
>authenticatedAttributes/signedAttrs and give you the hash of that - but then
>you're a bit at the mercy of whatever hashes were used.

IMA also uses pkcs7_get_digest mainly for the purpose of checking if the
digest has been blacklisted:) So you making a SHA256 hash for UEFI
blacklisting will automatically resolve this issue.

>
>Further, we need to think how we're going to do PQC support in IMA -
>particularly as the signatures are so much bigger and verification slower.

According to my experiments done so far, for verification speed,
ML-DSA-65 is consistently faster than ECDSA P-384 which is used by
current CentOS/RHEL to sign files in a package. 

The size of a single ML-DSA-65 signature indeed increases dramatically
compared with ECDSA P-384 (3309 bytes vs ~100 bytes). But I'm not sure
it can be a big problem when considering the storage capacity. Take
latest fresh CentOS Stream 10 x86_64 KVM guest as example, without any
file system optimization, extra ~189MB disk space is needed if all files
in /usr signed using by ML-DSA-65 where the disk size is 50G. But I
don't have enough experience to tell how users will perceive it and I'll
try to collect more feedback.

For the details of my experiments, you can check
https://gist.github.com/coiby/41cf3a4d59cd64fb19d35b9ac42e4cd7
And here's the tldr; version,
- Verification Speed: ML-DSA-65 is consistently ~10-12% faster
   at verification than ECDSA P-384 when verifying all files in /usr;
   ML-DSA-65 is 2.5x or 3x faster by "openssl speed"

- Signing Speed: ML-DSA-65 appears ~25-30% slower when signing
   all files in /usr; ML-DSA-65 is 4x or 4.8x slower by "openssl speed"

- Storage overhead: For ML-DSA-65, /usr will increase by 189MB and
   430MB when there are 27346 and 58341 files respectively. But total
   size of pure IMA signatures are estimated (files x (3309+20) bytes) to
   be ~87MB and ~185MB respectively.

>Would ML-DSA-44 be acceptable?  Should we grab some internal state out of
>ML-DSA to use in lieu of a hash?

According to 
https://www.ietf.org/archive/id/draft-salter-lamps-cms-ml-dsa-00.html
ML-DSA-44 is intended to meet NIST's level 2 security category. Will
NIST level 2 meet users' security requirements?

>
>David
>
>

-- 
Best regards,
Coiby

