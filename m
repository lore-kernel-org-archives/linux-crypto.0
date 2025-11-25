Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B3032470A;
	Tue, 25 Nov 2025 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080250; cv=none; b=KiV4Z99zMsTCU68aLndB6Ja3u7BgwVFtJVKdojtuMe7JumxI3JALTcjfiqQ1GODtUa+7/9amWSWKt3q+ODn44fp3+bngtumLWCBNOcgpN4sFLKY5YbySE2sm7Mm6C9cdBL+3M5UjdzZtUsfTR8TEeL+wGGTUiWCodMWtHyE08EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080250; c=relaxed/simple;
	bh=3FKv5aLjimGVl+0YYJReTdnukho31uuGhNJwMpjAnoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EaxyFRecZlL+GZQFBPttNUqbt2ijs24fmspz4us/X+8wCizMK56FOZ1YX8hJKey9BwO153WH8Y/Cz2bT7T1aC5gNOLtu3PJ1bEAVyzqrBcuw8oN7GVV1LNdP3BMa7NcqX8lVUAMYzyxfxGuLw5fiqD65W1Ul5J5hyWdoWM21hlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=4cdJrNqa; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="4cdJrNqa"
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 0FBE75AB13;
	Tue, 25 Nov 2025 15:17:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1764080247;
	bh=3FKv5aLjimGVl+0YYJReTdnukho31uuGhNJwMpjAnoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=4cdJrNqaOkz9O/XGjxTEF9Q++fnK4VPshQF30DqerbRcrHiaZvyDQPb8wv4r7kWHD
	 GEPJ4TftydX1NPAdheJL6I5wXSupdKWnesGA1XQIg4CX3gaWL/8Hqz5kLmc7Q3iDHl
	 Zig8JQT9UuSZPc3WD9dC/wRghDcJhK0A2ubLAC69Y7ihSse60f0TIEgFe1DektCJOk
	 VqplO0l0gLv/HeGj5r/JoacJQ39lE5PRQi1+GXa9OiwYLZHl7o9gPZh+I/A3Bwliia
	 UKqRnscw0ze2v2fLvWpLujnPKKy6UE9LI0RddGXtb+tPh17X1gxAeumxB4VyeAe4Aj
	 Xqy8YM0cKqJEQ==
Date: Tue, 25 Nov 2025 15:17:25 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Ashish Kalra <ashish.kalra@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>, 
	Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan <gaoshiyuan@baidu.com>, 
	Sean Christopherson <seanjc@google.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Amit Shah <amit.shah@amd.com>, Peter Gonda <pgonda@google.com>, 
	iommu@lists.linux.dev, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
Message-ID: <jlut4svio3kbj5x4e7xjv3fra3ekt5jjswq7awue7idbp366kk@2dgmes7xtlol>
References: <20251121080629.444992-1-aik@amd.com>
 <b56046b5-1fa2-404f-b99f-353ec8567621@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b56046b5-1fa2-404f-b99f-353ec8567621@amd.com>

Hey Alexey,

On Sat, Nov 22, 2025 at 02:35:03PM +1100, Alexey Kardashevskiy wrote:
> I should have cc'ed linux-coco@lists.linux.dev. And vim ate "AMD" from the
> subject line. Should I repost now? Thanks,

A full repost it not needed, imho. Just reply with linux-coco on CC for
awareness. Everyone on that list can then lookup the full thread on lore.

Just make sure to Cc linux-coco on the next version.

Regards,

	Joerg
