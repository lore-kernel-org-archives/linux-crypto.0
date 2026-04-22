Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2319346E66
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881821; cv=none; b=CB1iusV6fIzwyuHiNM/VPKPrSNH1RALyY2HcsW1TXS3+YAIt/0z8aXlZ/sSUwc2KheMOzUgDPGhzHkaQaDFxNWl/F0W2pFngl83wAfoj692t3wlxrzh99gC4fLLeEIl9La7L8TKXQOKmwukRTiXHKKkKEOo7Shrz9f9tBWYQFeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881821; c=relaxed/simple;
	bh=UKlkHzICRJHH/6Jan3cAogPFr780ywC4cRf5Em855q4=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=bxw1V9WWsC/SVPmVYy0fbO/AtWNXZNGG1kBZKYb8fw8Kb94HnqtP/7ZmVLBKlPpqrZalYiIwosJ8EfTyLwhtX4MKXni0Pp5WoZ00b/WsNNqwCRJOgf/hQEnVNt1Lkr8z7U5jjnbHDQpjfIRSpi1ekdZ2ReEcPBFrPkrYuj2wPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Au/LcE5i; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Au/LcE5i"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7986e538decso58458437b3.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881819; x=1777486619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k5olhXnIscd8Fz0fGU3E0klOq/HsiOUVkCzhktPLD2M=;
        b=Au/LcE5iHKSZXioXjk7WemlgpSYbcYvBb85e/URaq2U4e9rIUoxFYW7NdTAVx8RqkD
         U0VTEJp+10JFTCmKGYMTW5uljDlf5jRGC6zyvKt/QTUywhi0R47OTcJFhY0Hpy7jcASI
         fcjEoVuRnNDk+CwEqcUbc+LXuhZyke7Uyzso8H8/RJ/TFt/junlhRyTx1urd1Yb3k2So
         OaLo4O9zSjT0+Qd9h+kPmC+zK4Rb+z/eDo4SzNhXroUx+szKLJKvp1BuhkU6NEkDMjnh
         /uqLKcNyseHrdf+Fynq0w2Zcv0vSK1qd3Hq2Vj3yeUsa1OF0gZC66FGXFMzAKTv1MPSm
         V5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881819; x=1777486619;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k5olhXnIscd8Fz0fGU3E0klOq/HsiOUVkCzhktPLD2M=;
        b=OXqVwrF0b0kKw1x5XQ82eGxrz1OZeJrXUpNF7rKN21bfDROvJKaN/yWu5m3m8E7qjF
         Pj++KJ2Y6TbUmRq3SeqIyhsM/aMHfqysKuBgTwp+NaYzEgeLm1RvhWQZcOKpS5CGcySC
         zCoWlS+cF1JXtSn98TPHx478muUQkUPbV7rTGWS4Y0IvCbXYUiS4durxFcfzKsF2jsQY
         VJ6V1oWl7TJNSiV4i3+TyugLT+FlGBzQZwpPi+38cyjXjuYMiytNfIv4DJnXT6PzKwdC
         9qcdvyc+6U4ZBYp9qJahGVw6fY4NSiQonbI7AZN1+ygLMowUb97jdm8jSZPQ8f8zbKEm
         WHEA==
X-Forwarded-Encrypted: i=1; AFNElJ8MTPZ94ldajmMpl+DNWb22xoGEQyhZTwVrf1WVUfzbcag2HTqtITKHfmAxTSIz/lk4QFJzBiFhLqU8krQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLs5upO724PWTZM8jbval8iQ1T2hj71W0JVxCt5ELmXywurhFy
	3MW1SlQx79Eb4icexrOiVuu9e0DsF0XrcVQ9fXMrY99SuYJau/a9p9M0
X-Gm-Gg: AeBDieuJcSIS9TjdoG1LCN/SlyEm1jQAZhnPHAwKmkiYoVH7WZeGWTKo3GEPIUW9qbU
	CsVKIywBmdNik7NVwa56pj45lauLvfMCZ3VR9FoG/bK7hn3ohtpUXEyLDjSXo9W1SVONRkMQnTo
	Lszrc4ls1d5vggXOsHAWdIpVr4rJPSPzUNJKiNa63vplIocZCXgSgqMOwLOrh3pR4U128mCZ3+2
	DT1D0y24icIjEthmk5jg5pwQp1eJzcFpQXh4t3XI5Ye19GSq4WI5NPq5YW6XIgiSrTTMLLStZJk
	N1K6ZugDtuB4aLuUozP9M6x+4PXLs9TovlKozm5DTcGQD1ys9++Rqwb1ptj+CPOMDghVmrGeiHH
	Urxhc8IM/GmY+BJE5RO8tLBNNz6gPa3E1rvmlqAi6kWaotm3J/X/JslbphBl/dwPYPGW/8KNoMM
	Ppzd/B4ZyqQlFzvO7ms4REkHSXqfBMwwV3E8k0
X-Received: by 2002:a05:690c:348a:b0:7ba:f414:cd28 with SMTP id 00721157ae682-7baf414d250mr133922307b3.42.1776881818926;
        Wed, 22 Apr 2026 11:16:58 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7b9ee8be8e4sm74318757b3.14.2026.04.22.11.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:16:58 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:16:57 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_5/8=5D_lib/crc=3A_arm=3A_Enable_arm64?=
 =?US-ASCII?Q?=27s_NEON_intrinsics_implementation_of_crc64?=
In-Reply-To: <20260422171655.3437334-15-ardb+git@google.com>
Message-ID: <547D9EB2-4A67-49A9-8C8D-3ADD22123B1A@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Ard,

Wow, 20x improvement is nuts.

I like how you handle this change *safely*

Like.

+static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
+{
+	if (len >= 128 && static_branch_likely(&have_pmull) &&
+	    likely(may_use_simd())) {
+		do {
+			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
+
+			scoped_ksimd()
+				crc = crc64_nvme_neon(crc, p, chunk);
+
+			p += chunk;
+			len -= chunk;
+		} while (len >= 128);
+	}

chunking the SIMD work at SZ_4K to avoid hogging the CPU and allowing
softirqs/preemption to process is a great detail. 

It’s easy to just wing it and throw
the entire buffer at the FPU, but respecting the kernel's latency
requirements is better!


Reviewed-by: Josh Law <joshlaw48@gmail.com>

Thanks!
