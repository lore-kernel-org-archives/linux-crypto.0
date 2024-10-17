Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402E41D8E01;
	Thu, 17 Oct 2024 12:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729169287; cv=none; b=qip4Vmp0dnb2BwC48htKuSUwSdWQyd4mi6OoHRzitzLQ9RPpUC2U5PBUsVoN9gqt9cWCtf5uGpfKGYzVA2DACM0VsGVk3v68aHTdkGMVZy4zlMtPJRnFucfebBobwCS47QZ5R3o+YhXUz0RVAgXQP4QJ2FVcjSmZRBRVNmT7WwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729169287; c=relaxed/simple;
	bh=kr812VilSUUJGOhSMVCcE5nyWwDvvE4HGpjFCp6VRyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNdb8b+vK06WnX2tuLZlpN9E9zD20def3oNxaGEQclJ0j44NknRAm2jTCFJXrqmRB9inhYTq+lgGK3+LhQr8bZVwa/agOKazU5kAU1mYZUmPesTvUVrZ+J/55bfPP0L6kQ+Zolz3Sby6pKrrH1mVCp5NkWHmmOk1NgkuUYhq5kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCFb9V3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCFb9V3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5978C4CEC3;
	Thu, 17 Oct 2024 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729169286;
	bh=kr812VilSUUJGOhSMVCcE5nyWwDvvE4HGpjFCp6VRyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCFb9V3y131MlmswJPfDwZNa1Blqz7Yvt/YgE07QsRElp5ozCPnkneDetI4nBXpoV
	 RLjgU9dQ7pP05HknHoMyuGoZJDX2AcQIHQvB55jc96THAFofLUCcpRffn2TFN9X3rQ
	 HpWn3n5DcBfAdVnbSpPEoODCrXeFb7Vxxs2SSE90T3MnyW4+ZSE8AqzzZh3lHBswFb
	 mS2EclkiymXWynDitkCF25KOXvaKuEcoJwfqGfAvbTctqvWGTm6Vbuud4RFq4d3yPv
	 pN3lPJcTY/PTKStNl62BrmI1YrK8N9fJAzBLFD8MUT9oEUJ7Rut/RKBUqOrmZuZtN3
	 FNO+ZwrvCJ87Q==
Date: Thu, 17 Oct 2024 07:48:05 -0500
From: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
Message-ID: <20241017124805.GB3032377-robh@kernel.org>
References: <20241017004335.27471-1-ansuelsmth@gmail.com>
 <20241017004335.27471-2-ansuelsmth@gmail.com>
 <dg346xguo5cjx6yotnrdpjyp7n7wwpwnrjvybrrbocekhltpmg@s2j734wd2rnf>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dg346xguo5cjx6yotnrdpjyp7n7wwpwnrjvybrrbocekhltpmg@s2j734wd2rnf>

On Thu, Oct 17, 2024 at 10:23:54AM +0200, Krzysztof Kozlowski wrote:
> On Thu, Oct 17, 2024 at 02:43:18AM +0200, Christian Marangi wrote:
>  +
> > +description: |
> > +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> > +  integrated in varios devices with very different and generic name from
> > +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> > +  developed by Inside Secure and given to license to vendors.
> > +
> > +  The IP block is sold with different model based on what feature are
> > +  needed and are identified with the final letter. Each letter correspond
> > +  to a specific set of feature and multiple letter reflect the sum of the
> > +  feature set.
> 
> You write it is licensed to vendors, so are you sure these could be
> used alone, without vendor customizations/hookups etc? I think you
> should have a dedicated, SoC-specific compatible in the front. I am not
> sure if this was discussed already, though.

Probably should, but some reason we haven't on other Inside Secure IP. 
Perhaps they are just simple enough from a DT perspective to get away 
without. Also, there may not be any SoC associated with some of these. 
If there is an SoC, then better to add a compatible to help avoid any 
future DT changes.

Rob
