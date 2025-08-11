Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C243F26FA77;
	Mon, 11 Aug 2025 05:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754891927; cv=none; b=H/5/8++vQguBWpbcteGzjqIO/MwWdtcjRaqQLAoOZJfPx9zhcVB0OQO2rBAneJBq+HQWZCG0NliVWjwY5hxSDuIHxnuQuyFiJ1lpph8MQeKyhmCVWhIBtRMTbwDQO9fcyDUg40BESkbVNQTNxW6jjdnyRfEfCxpwXpi/3bZ8XBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754891927; c=relaxed/simple;
	bh=8iMvpF/6ZCtyrpqM9G7xHRgnKPg2HV2n/Pokozp/QNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbUG1ViIpadUB3FVqvmSNZGQFlJzkKkR7/ig+RHbWvVQ19gy7Zf3VoUR9QKYAj6lSq9ZeNP5XQOmz6bKxZ6JbVRbf6OBOTEDeBfGXqbf8O7tVqr9/TEl/ze9RaaNHEAYjUu9Idty4qDN+nKmJSU2LDfoXjEQQf1FKSmDP37AqOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kHwpit0u; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kHwpit0u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754891926; x=1786427926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8iMvpF/6ZCtyrpqM9G7xHRgnKPg2HV2n/Pokozp/QNk=;
  b=kHwpit0u532/aqcz6GXKiz4wS62B2yx5EKJo8yQkdM3cplBCtiM0bsXK
   LNxwhQ2UftPho4tARKA3/GsRyvd4bNRdV2AkfzmbnCrGi+PiJOHgZExkh
   Kz1HXcxhgvIc+gTytXr04Qlnl09+sjXeKw+ewwNUrFEFiiGYqihEpbDyG
   nqFETZSzaCRLnb0kJwp18/+UEgkTffN9x4rnz/19zLeVoqx6wTaOeqrwm
   iI0APHDymv4uAN6F4ebibrG+MKQhJeOfKGi25epOokFTK3xmZWt0NJdMx
   JQYqI3/twpgyfpfCBjo+CcP8BWzCJKFCLXYBDKt0gRoAzuaieQX7Xcenz
   Q==;
X-CSE-ConnectionGUID: 7psi+W/mSjKzvHriKx08Lg==
X-CSE-MsgGUID: no5DXc2rSJKFVpuqIlNQ/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="44722634"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="44722634"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 22:58:45 -0700
X-CSE-ConnectionGUID: 1QrqDLT2TNm0pMRnd1YSiw==
X-CSE-MsgGUID: 7h0fH+iEQfOAodnLKRosBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="169935705"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa003.fm.intel.com with ESMTP; 10 Aug 2025 22:58:43 -0700
Received: by black.igk.intel.com (Postfix, from userid 1001)
	id EE91493; Mon, 11 Aug 2025 07:58:41 +0200 (CEST)
Date: Mon, 11 Aug 2025 07:58:41 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-usb@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>,
	Michael Jamet <michael.jamet@intel.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] thunderbolt: HMAC fix and cleanup
Message-ID: <20250811055841.GR476609@black.igk.intel.com>
References: <20250731192545.29869-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250731192545.29869-1-ebiggers@kernel.org>

On Thu, Jul 31, 2025 at 12:25:43PM -0700, Eric Biggers wrote:
> Patch 1 fixes the HMAC comparison in the thunderbolt driver to be
> constant-time.
> 
> Patch 2 simplifies the HMAC computation in the thunderbolt driver by
> using the library API instead of crypto_shash.  Note that this depends
> on the HMAC-SHA256 library API that was merged for v6.17-rc1.
> 
> Eric Biggers (2):
>   thunderbolt: Compare HMAC values in constant time
>   thunderbolt: Use HMAC-SHA256 library instead of crypto_shash

Both applied to thunderbolt.git/next, thanks!
