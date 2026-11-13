Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794602821;
	b=l7C98R1e5Vgve6aE1i7Ua5XqAc2j3B+Qf1/z89jos94qmngKi/imL0g/AJD83DrM/yPD
	 YlojUChx/OefknnuBmqKT9n0kAdUJy72MgliOscpMNkQvfnb9rzOHGVyu+9zj2o0gwe3b
	 KlCxMF6oIuK7Ax90xmmV8WGhWDBH04+LUzfZVxCeqF4NMPQaz6GZbsEo0NpjPFyYffES5
	 7zOgmdBmx+ylB1AxSHJx4gc0bpy6gQNwZaGcT+s+WOeNQetb0ZvApPU5EcZ+Qyg+U8P16
	 Qjz7iMJjeFysZ25ZkJJn56VCjGhYBAFdNbeoyUmSW/EfeCPAWUCG6+Eq+1EppFD02pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794602821;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:Cc:
	 Message-ID:In-Reply-To:References:Subject:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Content-Disposition:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=TmhWV6KAmRo8Cnh1XIwlaMrQHP42R8KdW7fspor4seU=;
	b=bi+LBWc8T1P51Om8kmZ7L6L5ofhbUNj2lyiQRsg6NX3QFAPodMPJ+ruuM8kGwMd9as+s
	 MuWG8JFaH81rPvncZ3DRE+b1F+F+pMi90Vff+0mdHxCNvbK0vtFIzXPO3KeTtTfH3cXbj
	 32IM2DIMuisBYka9QxSe1CYYnkqCFuZQzM5l/LGAuggTkoIJA+EX+3ovIaMzvNj3+z1RE
	 UJCIFcsc7S0+xEFyRE5YGtE8f/qGeN2VrZS7HmutfyB1wHMyKRavdyFg40cDUc8bzVeI/
	 sAQLIIpzSpWwBR2C5tRGxE5DYxiee/QTjBHYpoUX6qc+adw5PWfpOOGJGumWNC54hGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=m6YqWR1K;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00598606A32D;
	Fri, 13 Nov 2026 20:47:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00598606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=m6YqWR1K
Received: from [100.96.64.252] (unknown [52.179.129.152])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2EA1220B7167;
	Fri, 13 Nov 2026 12:46:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2EA1220B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794602816;
	bh=TmhWV6KAmRo8Cnh1XIwlaMrQHP42R8KdW7fspor4seU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=m6YqWR1KPTwK0fwCsBnFR/zxFTq3e3FX7q4uMXubl7k64iDsTsFRgxz6CekGnUWLQ
	 8QGl/wjG3mgIsAYQN0w4fhpfhvBc45V6YXJDEcHlSFnjqUte7Eh3l7RQNOh0P5OPtb
	 6x7uFwLNkON5FoTeweSB24E5E7Fezs7iluJITxiA=
Date: Fri, 13 Nov 2026 15:46:57 -0500
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
Cc: "=?utf-8?Q?herbert=40gondor.apana.org.au?="
 <herbert@gondor.apana.org.au>, "=?utf-8?Q?davem=40davemloft.net?="
 <davem@davemloft.net>, "=?utf-8?Q?horia.geanta=40nxp.com?="
 <horia.geanta@nxp.com>, "=?utf-8?Q?pankaj.gupta=40nxp.com?="
 <pankaj.gupta@nxp.com>, "=?utf-8?Q?gaurav.jain=40nxp.com?="
 <gaurav.jain@nxp.com>, "=?utf-8?Q?changwei.zou=40canonical.com?="
 <changwei.zou@canonical.com>, 
 "=?utf-8?Q?linux-crypto=40vger.kernel.org?="
 <linux-crypto@vger.kernel.org>, 
 "=?utf-8?Q?linux-kernel=40vger.kernel.org?="
 <linux-kernel@vger.kernel.org>
Message-ID: <4155D08C-95D5-4636-85A0-709911E2CB2F@getmailspring.com>
In-Reply-To: <20261112081543.503706-1-sahil.malhotra@oss.nxp.com>
References: <20261112081543.503706-1-sahil.malhotra@oss.nxp.com>
Subject: Re: [RFC PATCH 1/1] crypto: caam - fix in-place RSA payload DMA
 mapping
X-Mailer: Mailspring
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Sahil, Changwei,

Thanks for the review. 
                         
> Could you either check req->src == req->dst (before the leading zeros are
> stripped), or at least state in the commit message that only an exact
> head alias is handled?

Agreed. I'll detect the original req->src == req->dst alias before
leading-zero stripping and handle the advanced-source case through the
destination bounce path, rather than limit the fix to effective-head
equality.

> so the alias case could simply be one more trigger for the bounce path.

That makes sense. I'll use the bounce path for multi-segment aliases
instead of rejecting them with -EOPNOTSUPP or adding separate SEC4 views.

> Could the two of you agree on an order, so that whichever lands second
> is rebased with this in mind?

Changwei, would putting your series first work for you? I see v5 now
uses fixup_dst; I propose basing my respin on that infrastructure.
I'll ensure all failure paths release any allocated bounce buffer.

> Could you split them into a separate patch?
> That makes them easier to backport.

Yes, I'll split out the sg_nents_for_len() validation and place the
checks before destination traversal and bounce allocation.

I'll also add the requested Fixes and stable tags to the DMA alias fix.

Thanks for offering to test on i.MX8M with CONFIG_DMA_API_DEBUG.
I'll copy you on the respin and identify its prerequisite series.

Thanks,
Jeff

