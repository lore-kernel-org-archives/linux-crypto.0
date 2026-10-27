Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113674;
	b=vWixBQ3TW4LF4lEcSfwOE5UETo1q8/oSnaFeE9GlHNrziZTbkwRA24OGPwrtJdlai427
	 /ZCbYuWcs/TYnBq1B3zvJKChYTSxI2+Wm/TdXaoJscbTlNq/gsKPX3YbPG0zkxVF6tiVi
	 GRunK1ScOwdfYki25GqzOH3c1rFNUp2i3dl0+WBctHvZh1c2x6IyqFbqhxe62K4+Zh/VD
	 X7vBucqMsSDNgo920mcZ55vo5jhO7/zi6s4lFnDrVIqDfpjbOTAoIE7b81fmn2HWt0tXC
	 VjzAxde/lzygZ0zCbykDf0KpbHrvAbrAFS8Jc37KJ9eQMDw+GOqH6JKoq70AeAxiLGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113674;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=OjJ9mUY1yE91LsNggPu9Owusyk/2pZUa9csJW57ZG0tzGAdLQp0k0Hsap9uzTVsMKm/2
	 Lrf4DAK72z9sOveqPLdPXn8h93Z3iOvtG9tJzsUIg1re0c9WOJw4/7/M+Tt+/lAHO6kPT
	 0/yFLKw/uvKUSXGbcyncdvkY/HS9NakKcYrZpw3QmZwd9NjE08EemauyUaafwslH/vXXA
	 DBCs/888GPfz+PGBiEogP6+HnW29ozDosAJbI/Omylke3W/+7ViWWkmFtIx6H5Ogu8kEN
	 M6iX4ZcOENDYXuInY5LeRU9N4M7faIJAVPx9vWyPw+UpuGeKm11b+CBx1jsCRkTixyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB06C606A31A;
	Tue, 27 Oct 2026 15:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB06C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4142968C7B; Tue, 27 Oct 2026 16:07:50 +0100 (CET)
Date: Tue, 27 Oct 2026 16:07:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] raid: remove obsolete MMX optimized code
Message-ID: <20261027150750.GB14436@lst.de>
References: <20261025191207.86590-1-ebiggers@kernel.org>
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
In-Reply-To: <20261025191207.86590-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
