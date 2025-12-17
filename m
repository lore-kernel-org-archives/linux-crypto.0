Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561A93A1E8C;
	Wed, 17 Dec 2025 04:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765944796; cv=none; b=TbwzaWVm5vbzZqHnBhGBPFWEolU+kOnyhp38V4yTMNZlMvOmXQHgwXyeewWFElcxiY5Nt9tjHa4b6LUzf78sdxHvvwocjfR1lpPF1GTO5s6ZDEj+LZ4YsV+nv4FuZ9JUqqsGQw2m8YlmKI72IiAooTy/m2xF8aaxIy6CahSUVw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765944796; c=relaxed/simple;
	bh=U5BEfwFw7nY3n5GmlzJM7kxcCTmb81uhWhZQBWRwF28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+51Amh8jt692UcA0MDMkBViOtRF4Ff5YFezjQ2QZ4Xq/+mETZHbTppo7QxJusf8VL9Sz7blbAAuzS1dkBEYJZqCplyYx7GiHkEPylJvyLcBBNHH+uVkJMl5DHgboDCyXi5Q6qD2FJQ6yqNJ4UlSDZNfgYp+397PF+4aC5qHwf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WL7E4wpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WL7E4wpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D8FC4CEFB;
	Wed, 17 Dec 2025 04:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765944796;
	bh=U5BEfwFw7nY3n5GmlzJM7kxcCTmb81uhWhZQBWRwF28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WL7E4wpFM0mIar+VUJhSxRYfqfyI7IbHQamQP49Por3n36Mhm/GY0MSAExoNtRw6x
	 J9dsvZmB80FUmTTmC+RFxIP8veBlQoHoQ7rcxL19tPdDhb74VdVMGsErBJVv3ur4hI
	 KpyjxAtPMjSIKSpuZr5sVpV8PoP5Htd/b6vYbYW0VAw0hTd3sgkmFF8cYF2afUkaqy
	 chRyXBBrIshvvTUnqM5iEFkctJWjWRoReSUZe4DXtYaNFxO4W9wvIZ66rQC0YxZR57
	 EOZ+acnfuLOJypSheO/Ec+86j/lanD+HYLU1GaR5uVWhGMTs8N4ZnkLCLAg2RgfKyE
	 SOpSIkxgVPreg==
Date: Tue, 16 Dec 2025 20:13:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Li Tian <litian@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Simo Sorce <ssorce@redhat.com>
Subject: Re: [PATCH RFC] crypto/hkdf: Skip tests with keys too short in FIPS
 mode
Message-ID: <20251217041307.GB3424@sol>
References: <20251205113136.17920-1-litian@redhat.com>
 <20251209225401.GA54030@quark>
 <CAHhBTWuXQY5CBLTT+-+WsTDw6Pua=Kt-4Mrj6+qiEjKEi+SSSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHhBTWuXQY5CBLTT+-+WsTDw6Pua=Kt-4Mrj6+qiEjKEi+SSSQ@mail.gmail.com>

On Wed, Dec 17, 2025 at 08:08:48AM +0800, Li Tian wrote:
> On Wed, Dec 10, 2025 at 6:54 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > What problem are you trying to solve?
> 
> Eric, as you've said "keylen < 14 check in the new version in
> crypto/sha256.c." was forgotten.
> IMHO, it deserves recovery in terms of FIPS. And by the time the check
> is restored, the hkdf_test
> cases failure will likely surface again. Hence the skipping in this proposal.
> 
> Li Tian

Sure, but there's no reason to consider this patch unless the incorrect
and problematic keylen check is added back in.

- Eric
