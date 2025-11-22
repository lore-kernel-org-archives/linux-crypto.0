Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AD3D544;
	Sat, 22 Nov 2025 03:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781459; cv=none; b=Mh7mqZ3BpepJhPxYHEOHA4O6VwELr16gS1o7NQWyVPz8ryVQ1eS6IuyqDZMvebMhk8OvOYLZd6zysC7xTPQ9yR4YGz6Ziq6rdZyhQhWm76QQ7IyRL/bgmOSBb8/CIrX4n/XqqzP9uQvaG4H+GDc9LLHSjCRDYl9u0gYEis+rfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781459; c=relaxed/simple;
	bh=49kjNaHGKfzrMvykOZ7J25un7aq+pvFLTkEC77OXyJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvtDwQHPli8mGzU/RBObw6OBlDH7lMJ5Avxs3/oDmN4+mZes4RZQXg7nOPJbYdqjHCrImA73IFlvTjyYaEJPR5rkkBRw6Cs51kkL8fs+Ll9+Ktan+vLrbmWHeUXcURGA+5kPy/Vwse2UiMAH8x0FzG/AhAE8LzxB+hsrKRCuA18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kP8TCZWI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kP8TCZWI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6m8XnT+e+a12kgO1uCENfrTn9a5Y/h61Rpk0gERo5NI=; 
	b=kP8TCZWIw/ZlW1ubCRhqNLJNKTL5A/sz4uLGjNpTM06cFB96q71XPwT3rejwBn9uB69z72+Hyf4
	28vGTymGO+Ug2V6i5+VGKn8aJ8z3ErpLRqdaWTMbI6Hipvt/F+AT1qjeGNWbyKe4ySn5TBjmc2LKy
	Mc+Y2EM0jtAjbK3436yEvXUDAPiTAi/agXCjfqzpeF3MGSKSpauxXE3N84SxR4BHbf0oi8QuVkFhJ
	nrlzAEPC1LdqBHCBIep2B/xothr+XAeAEFNObvuUW9B2tigB0Ji1vf97XDP6DruzhrdKlUkgNt79k
	IPMGVn1BuZ5nLUY1ccWsjhpQhtYC+Hq9LhHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe7u-0056Vl-0X;
	Sat, 22 Nov 2025 11:17:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:17:30 +0800
Date: Sat, 22 Nov 2025 11:17:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"robh@kernel.org" <robh@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>,
	"Botcha, Mounika" <Mounika.Botcha@amd.com>,
	"Savitala, Sarat Chand" <sarat.chand.savitala@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"Buddhabhatti, Jay" <jay.buddhabhatti@amd.com>
Subject: Re: [PATCH 09/15] crypto: zynqmp-aes-gcm: Fix setkey operation to
 select HW keys
Message-ID: <aSErShjDlRaTEoL9@gondor.apana.org.au>
References: <20251029102158.3190743-1-h.jain@amd.com>
 <20251029102158.3190743-10-h.jain@amd.com>
 <aQwlEgMlYr8EPrTo@gondor.apana.org.au>
 <DS0PR12MB934525C9192C679D5AE681DD97CFA@DS0PR12MB9345.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR12MB934525C9192C679D5AE681DD97CFA@DS0PR12MB9345.namprd12.prod.outlook.com>

On Tue, Nov 11, 2025 at 11:57:33AM +0000, Jain, Harsh (AECG-SSW) wrote:
>
> We have two types of key registers
> 1) Registers to save user supplied keys like ZYNQMP_AES_KUP_KEY
> 2) Register Where H/W internally generates the keys like ZYNQMP_AES_DEV_KEY and ZYNQMP_AES_PUF_KEY
> 
> Fallback is for 1), because driver has saved key in private ctx and can be fallback to S/W.

OK so in our parlance this isn't a hardware key and it should stay
with the plain "aes" driver.  "paes" should be used for hardware
keys with no corresponding software key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
