Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F35B1F4182;
	Fri, 21 Feb 2025 03:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740109403; cv=none; b=eEm0vYuimUwp/CxQEyIFxvOV2ol8kpTb3xZEvy/MPiSLThKdBZJ7kO3hEnMslUnGzVpmTD252fvgjIiSuCWUR1u56bQ7Aeqw2mp6Fesl8ObEAJbbYW/xmWt8b4qu3hXbin1DzAU4Kamg/CbKROZPzVnkhBypNcXDMj8K+IEaspw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740109403; c=relaxed/simple;
	bh=9xiR0WcQ75NciBVOvowr3/c1n8XpeiMI0KUaxrxBNg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjeB7N+F69k2KP2WARyo9Svfv5WOC8aIY0SI05KNAiZ9c3D3Zm4ileICZnRUc1XfwO1p+YyHrYunIio+AQ/utI9UA7HxJxnt5BRV7BIVxH1Oy/Qgz+r8Ku+MAHHiWfvArhVJAkXIHdjh9v50N8upTjAMropIVLFKl2oysakcuXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VCYj/aER; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VCYj/aER"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tU3HGm8jAkcYfAhXFLQlbPZELAW2UZ72fM84mdvotNs=; b=VCYj/aERgisjZ4Yf/pNXspGlcm
	Gp6LbrWu50kwsLjzP3oUn66JxOtxEBN7xx13QxOXyHyRkblOygt01XHV1GTy2qZNHi7R2/hw/paKZ
	CNt8kKCo+9FvGCTNvztHRxFoTKV3H1m6Oc6HkfM4qCqnleVLtcTVxyvg4YtEWt4gmj1/7h/Ef9atz
	Mr4V2FvzS/cfsFpZ+UiTl/njOMy+SbRlZKA12/fI95rZxlBMi1J5RIzY4C2jWSoUDRgg3cv2bxZ6b
	49s2w0dAf9NU6nJa3bKS7SuISM2sKYsXybeuHtTue0uaNTjXkMj66IYaAci+nr53p74rXUS9XLlwg
	Yq0Xr86g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlJwR-000Uyg-1M;
	Fri, 21 Feb 2025 11:43:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 11:43:07 +0800
Date: Fri, 21 Feb 2025 11:43:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	Danilo Krummrich <dakr@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Tianfei zhang <tianfei.zhang@intel.com>, stable@vger.kernel.org,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH v6 4/8] crypto: ccp: Fix uapi definitions of PSP errors
Message-ID: <Z7f2S3MigLEY80P2@gondor.apana.org.au>
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-5-dionnaglaze@google.com>
 <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
 <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>

On Thu, Feb 20, 2025 at 10:34:51AM -0600, Tom Lendacky wrote:
>
> @Boris or @Herbert, can we pick up this fix separate from this series?
> It can probably go through either the tip tree or crypto tree.

Please repost this patch by itself.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
