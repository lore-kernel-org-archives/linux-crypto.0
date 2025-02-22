Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748F2201100;
	Sat, 22 Feb 2025 07:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740208992; cv=none; b=BIZBwX2wh/ocGjb/6e+E44MO8oBXY90UYwHfC4VVdx7QYaMrD4hAZZBquBV8PJMrZLAUFA5KG+LvpfZnC/OZAxOHgFjT0SSMKr4D7+0H0o3mX+7uCon/lGB+Je8qe/5alFl1Gy6UBYFU8vNx7i43O4peiYu9qIP+OFFbp4AlEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740208992; c=relaxed/simple;
	bh=OVsdQyc5RJu/6Sz/McUMLlHMPGjeTFDI5czsaMynBFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4g5zuLJ8856xOr8BdyKlwsu/lToWviuJwcQpN9fAmNYAOuOyYFEU03eoJZ/HGB8QWOsfa3oM69XlmKWCK/IrukH3ZDA8D7zL8hhSmTIMZE7YoivVXKy0qlZKkilvQl04/iqBLawtHX2ht+gI2gnj+wvkjrJMZFk4ZrafT7IeOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YN+ZeC6I; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YN+ZeC6I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I/4UvPoi6I0ViXmTPRlmADW8zPALMISxjuds0SuIec8=; b=YN+ZeC6IPKT9Xdiy3YssrGh0s0
	UneqlVSOITrVq7w8oV+qqaVRx9w+WtaWkWB1zihcEzsBwl4x6hJCZcfNVs+Gc4N2aOnBPKiRyfbGz
	wiVYHvYEuqeObFeh0EZ2ls4IGLggBl5JanJIRnDEfGBwj3sfpZawyrsBEqTkJ5wQLKfyJ1rCY+Ja9
	1wwzafEGEOf2k4jQxpL1dUJfyEsrrQ1jF0IBw74uFB9QqKsDhzUPynBoenMne1l1eStp58VSKs9tz
	4AUxtuPFuLMcYSQ9OKlqNT1YPufV1JLlRoE0v+xAyo6nM6dfaIz2QgjFKoFR5VJb3G3axJZcck0Sy
	SWPni4Gg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tljqa-000o9k-0r;
	Sat, 22 Feb 2025 15:22:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2025 15:22:48 +0800
Date: Sat, 22 Feb 2025 15:22:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Barry Song <21cnbao@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z7l7SF6a8F-pKWdi@gondor.apana.org.au>
References: <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <Z7lv6JLax4S8vTtD@gondor.apana.org.au>
 <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>
 <Z7l0Hf-CFFjeKaZY@gondor.apana.org.au>
 <CAGsJ_4zFdHUPELSYDkrN4ie2c73L6e=FEdQbDL3JckS4unKFpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4zFdHUPELSYDkrN4ie2c73L6e=FEdQbDL3JckS4unKFpg@mail.gmail.com>

On Sat, Feb 22, 2025 at 08:13:13PM +1300, Barry Song wrote:
>
> Somehow, I find your comment reasonable. Another point I want
> to mention is the semantic difference. For example, in a system
> with only one algorithm, a dst_buf overflow still means a successful
> swap-out. However, other errors actually indicate an I/O failure.
> In such cases, vmscan.c will log the relevant error in pageout() to
> notify the user.

I'm talking specifically about the error from the Crypto API,
not any other error.  So if you werer using some sort of an
offload device to do the compression, that could indeed fail
due to an IO error (perhaps the PCI bus is on fire :)

But because that's reported through the Crypto API, it should
not be treated any differently than an incompressible page,
except for reporting purposes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
