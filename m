Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953022;
	b=KQB+od0SoFhczzh/36p5zdDMiBKTuQCEw48yVV81c6vpi0blGNrPiVYHWTyC1npNOfab
	 p4RFblTbo0Ga2U5x+xP6BmWXtVKXpk1CyoNaaz5q95w9uM9L/YySPIgqJbOo8HNcGgbbq
	 Gvps0W9UBulaNBpZQn5t+XpH1jU2/L+TI+RtMfY0TV1uCtQd8XxfSGWTM4RtetpRyiRg1
	 qNWtA9btZqQ11LhVn2lZMrSqo8KG9Y4pHifPMEQLodgV9nJ19FxEM0pYyLZJa8/QhKOQK
	 2lppcxx5kOTjoTUXlsJQbbNetkdB8sEqKXhl55RKoBTILi996COSfau/B/kBd9lWNdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953022;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=s/l8D3JxGDWZApr72OtI8O1AtYzAjh9O4VHecn90e54=;
	b=JsRCkYKCW8FB0HwCL4xd+J39yhetl6h56U+IaCCVxgrseMKSX7KsIpokDLViEp2E1Wtq
	 wvaiFrxd0x/duaM0Wqot73AfGYOMeIKA7zqIca7bbROVyTqiSlG0jyC9mNualaifH9/lw
	 olkyi+oh29mPiHYt93DJoviuF8iymxYBDCd63UWMgaRZ+QoG2ChbqENtbo9cFBLloXi91
	 8/YPPNDLh30JSoOJAu9pyIxNROndCmbcfJp/ovcM87e0sEfl/wrUQNG69yYoA5H0tzGrV
	 KL3e34be1MEdPJPxJYJsPdhdpp5Nsh2GsPjQ1kOQ1hpnvAY+cIDorPBIEknJxHnxQbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mOEXl7kH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF463606A32C;
	Fri,  6 Nov 2026 08:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF463606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mOEXl7kH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9A9F152B;
	Fri,  6 Nov 2026 00:16:56 -0800 (PST)
Received: from NH27D9T0LF (unknown [10.57.15.89])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2213D3F673;
	Fri,  6 Nov 2026 00:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793953019; bh=rXwsk/WrD524YCt9YFulEiGevSeXmR5lXAfW7nO0uAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mOEXl7kH10cLFRzfY3uiWfAjQghZxFUrj/EZPjV79cmkrjQNjtnD+sAeOBQrpYsqD
	 +AD453KGYXh1yJzOX0YxJoqcwvmtMxL8ffTGdmpHrisg2Ba85+WrP+Hl5/8wuLKiph
	 zFR8bpTkIVgBKef+2k5p2Ni0Ybbx7Vj2u20JpMfI=
Date: Fri, 6 Nov 2026 08:16:56 +0000
From: Emanuele Rocca <emanuele.rocca@arm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: use .arch_extension to enable CRC and
 crypto
Message-ID: <au2M-JBEobgEETQh@arm.com>
References: <20261105154145.557042-1-emanuele.rocca@arm.com>
 <20261105194220.GC3266627@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105194220.GC3266627@google.com>

Hi Eric,

On 2026-11-05 07:42, Eric Biggers wrote:
> Thanks.  Just to confirm, all supported versions of binutils and clang
> support this?  (As per Documentation/process/changes.rst, the kernel
> currently supports binutils 2.30 and later, and clang 17.0.1 and later.)

Yes, binutils supports .arch_extension since 2.26:
https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ae527cd876fe35de72d876d3484e194ccc66232f

$ git tag --contains ae527cd876fe35de72d876d3484e194ccc66232f | head -1
binutils-2_26

clang added support in 8.0.0:
https://releases.llvm.org/8.0.0/docs/ReleaseNotes.html#changes-to-the-aarch64-target

> A lot of the arm64 crypto code uses ".arch armv8-a+crypto".  Should
> those be replaced with ".arch_extension	crypto" for the same reason?

I think so, yes. Let me look more closely, I'll send another series for
those if they need changing as well.

Thanks!
  Emanuele
