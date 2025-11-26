Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39ACC3191C3;
	Wed, 26 Nov 2025 08:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146325; cv=none; b=IK6Ur61i/isEDLKcb8A3WI2QZuEaKu7p53MfYvks3sGF6ApMAs2870zUfpJSI6wMTf1ZjABZeBYVhnfr0QDEtlXmgH40BNb6gU8gke4mzhKNcuuU5iKQkkg52z+WTbtuna4zZOcZFnDdVxU7yicaQS+u6qUMou34K2eq/YBMBPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146325; c=relaxed/simple;
	bh=uSB15mBgdtedYCIi4Tln5fcQp1Yto607yFcD4qgc1nI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDCvP7N0lVYwEDQFcKIEFgzd48gGh7C0xh1DnQZ48yPkqFwoaf2OzAVW7JkHUpX1PQoGUhszr5uGnbRkETZjj9uDePUfMJh2OvRKuHWp6IjWfHuOUSleIi9LRPA8BDvqNYbcDHaO7MVeaGUpMZO3nYl/Pzgljl96SekgMu6ZMzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=VPpBGfn0; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="VPpBGfn0"
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id B8A9A5BE7F;
	Wed, 26 Nov 2025 09:38:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1764146320;
	bh=uSB15mBgdtedYCIi4Tln5fcQp1Yto607yFcD4qgc1nI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VPpBGfn08CttZZhQCELHrXC6E1DQkGVsc+GlLDDobn3/njSAR1okVXlwDSvNW9dbt
	 94XpOuyvvs+wJqXn2vNWD7sjoQlbha9rIZN/2uBV7p7i+8uzLZYo/mojjbqjZ1g8Op
	 94okBTqL2AiIt33iBGOY2wMBE05/JLpZI5NzVF4IGI3kMaF1DijbNhIibNzb/09LsG
	 sVCOBraD2WVbZNDjn9DgOfx8an8gZZbnN4sRVK/X/m+VnuF2QAoIZZpLRk7gtAD5KA
	 1+AhA2symh6vCQovDVR/QeIjbgN0Hnn242c4+YCkDzxLUYRPA0OkcTLcuxo1sHHku+
	 HxCpF/e+bXvyQ==
Date: Wed, 26 Nov 2025 09:38:39 +0100
From: Joerg Roedel <joro@8bytes.org>
To: dan.j.williams@intel.com
Cc: Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Kim Phillips <kim.phillips@amd.com>, Jerry Snitselaar <jsnitsel@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gao Shiyuan <gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Amit Shah <amit.shah@amd.com>, Peter Gonda <pgonda@google.com>, iommu@lists.linux.dev
Subject: Re: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
Message-ID: <hq6gtiznik5nfwd2bg7gtvm5qw3x5hc4a72s432snotfqyxmsk@jmfit3s6sxa4>
References: <20251121080629.444992-1-aik@amd.com>
 <692613e0e0680_1981100d3@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <692613e0e0680_1981100d3@dwillia2-mobl4.notmuch>

On Tue, Nov 25, 2025 at 12:38:56PM -0800, dan.j.williams@intel.com wrote:
> This looks ok to me. If the AMD IOMMU and CCP maintainers can give it an
> ack I can queue this for v6.19, but let me know if the timing is too
> tight and this needs to circle around for v6.20.

For the IOMMU parts:

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

