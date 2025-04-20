Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636CE43ABC;
	Sun, 20 Apr 2025 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745182878; cv=none; b=dBGu61+J7QFbi9zgWR2nrCXmeUS+1GHQRh9JiXvnmAQ8rP6lCfy+aWLk06RrswewsIVynnJ+j0gC0808gjuZJwXkSb+OYSEudLyn6eCdPxXl2aZaKSZsHxepCg9C5+y3wp48nhQnsliovinB/kyxyyAb2owUNB6b8r5H+oYe6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745182878; c=relaxed/simple;
	bh=i2lmUQG4IX7kqrr+nlEk+trjZPEWk3zVScNtA68XaRg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=BbRNjwo2uwWIfgBpHFs03wyV9oDIjwiPP6c+l6+yRReQe0kSlmr+6+hpgn1J1JOpsrBeNOugM2qe5brBhOBC0uIhlZMRmwBhgCj823vSCmGxhs3v2DX/foEYKw7qDFa3k8W5xHY/DJ7boffnQwj6LqKHl8Rkf+HUs7BTnKD6G68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lSGRZMjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lSGRZMjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4563C4CEE2;
	Sun, 20 Apr 2025 21:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745182877;
	bh=i2lmUQG4IX7kqrr+nlEk+trjZPEWk3zVScNtA68XaRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lSGRZMjFTFur/+Fv7REyIweICaS3qy69eGMzre/0Q4YS1pa41xuxpFIcmCbT3+jrW
	 es+BmXFqFsHsTw7wK7aoOA5sNdnzYdNYN7SWXh0CQ9gmwipNZeysbUbNaWUMxT8Y6s
	 pmC6q+E5xu4i49rAeStULtlZujAw/ea/MyKEUD+o=
Date: Sun, 20 Apr 2025 14:01:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
 <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
 <ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
 <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
 "ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
 <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
 "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
 <vinodh.gopal@intel.com>, m95d@psihoexpert.ro
Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Message-Id: <20250420140116.b6db3aafcc2f99569190c97e@linux-foundation.org>
In-Reply-To: <SA3PR11MB81202E35C1CAF0409711A1B0C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <Z8n5CCmELvpUwi3B@google.com>
	<PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
	<Z8tJOi5G_3dpK31v@google.com>
	<PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
	<Z88h1mPkYNM6yOGE@google.com>
	<SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
	<Z9mB5IbNEdNdtmUp@google.com>
	<SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
	<Z9nECMZW67F8XYoV@google.com>
	<SA3PR11MB8120A474C20104FF22CCE396C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
	<Z9n-OnGPK7BOdGxR@google.com>
	<SA3PR11MB81202E35C1CAF0409711A1B0C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


https://bugzilla.kernel.org/show_bug.cgi?id=220035 might be related to
this patchset?
