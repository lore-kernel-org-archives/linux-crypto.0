Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFBE324B3B;
	Fri, 12 Dec 2025 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765552204; cv=none; b=PXqjJu/2CY7sQtrb5SWvHUggidHxxkVbdrPRR2NOMZJ+gOcZaQiyUESo+xuyb0pb34Ne8j1CmqFhzeJ0vD8GpNHckY8QJaSg8YEPBTlNukbW2uqjcmZz/UVY0S6g/+zPlVu7VqAd6CKy3Yjpg32XMY2gafTP/ilm979fgGVpYY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765552204; c=relaxed/simple;
	bh=/PV0STkfCTyJm8MYDNV3QyZprEtTCeBMOcB7Z0OOTeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+2M2GfAhbOu/otjGuJQ8hKLI0WbJ3XLEn+KJ/xOD0dbuZ95vvDyOuU3Pu/0o7sUF9a346LrMdu1S44jK8Z43k3bEQm01U7ViK4xszOF52Nm05pjE/wQMtKku39wHY3pBmT3FrCihwZ3b/psXSYMdpOWFeRCd4E7B3NC6PVGHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VKdLNQVV; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VKdLNQVV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765552203; x=1797088203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/PV0STkfCTyJm8MYDNV3QyZprEtTCeBMOcB7Z0OOTeA=;
  b=VKdLNQVVtlpIb2Rq2dVF7aQp/n7Vye1aM17XLstvJTk1BPJpQr8sPFWC
   1MiKLu6QZn4sRcolb0SlMqCRJmVIM9j2/ZVx3jLaaFGpa3dPChIf+nfet
   RsWtEn+qYLglalL4uVrTFbdmNtxibn42ZoZ4K/f2kdKjf0hbLw6M8rz9E
   M+ROo8I88cuZjRbO8f/rrLK66+/tjNL3SiKUkCiaBKVpwEUeBUIypqlBK
   /ADIJSYVOYHfMiWRn3wgWwjntycEFczfjjNaQMEHazf8Z8FnO9VmFG8lO
   DwMiEyZlf3Ngp5Sw5DyZutch+qMBe2WoyJoGNAF+DReA1PY/XmFf0o15h
   A==;
X-CSE-ConnectionGUID: CBPDp7hAQdW8r1yxTc3zXA==
X-CSE-MsgGUID: X8WrPom1SR6+3c2o2IX6sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67430972"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="67430972"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 07:10:02 -0800
X-CSE-ConnectionGUID: RL4aPco+TpyRA01jwc33Yw==
X-CSE-MsgGUID: w9WQhZahTXmmhDgvv8vikQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="197380979"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.181])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 07:09:55 -0800
Date: Fri, 12 Dec 2025 17:09:52 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com,
	andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com, da.gomez@kernel.org, julia.lawall@inria.fr
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
Message-ID: <aTwwQLc0HjR_GbTY@smile.fi.intel.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <aTvLyFsE55MR0kHo@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTvLyFsE55MR0kHo@bombadil.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Dec 12, 2025 at 12:01:12AM -0800, Luis Chamberlain wrote:
> On Thu, Dec 04, 2025 at 03:12:39PM +0100, Ethan Graham wrote:
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> 
> As discussed just now at LPC, I suspected we could simplify this with
> Cocccinelle. The below patch applies on top of this series to prove
> that and lets us scale out fuzzing targets with Coccinelle.

That's nice! Much better than having tons of files being developed and
stitched in Makefile:s.

-- 
With Best Regards,
Andy Shevchenko


