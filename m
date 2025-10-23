Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444BB29A326;
	Thu, 23 Oct 2025 18:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761245049; cv=none; b=JfIL/ps4VKJC50HMjZO7swHCsRvSs2Gw4Mk3/+1pnKzsqzCIBuknfkkjJ5awSI+N6uT3ueC9Kss/vBqTWgV2Q+lbhxgeoyd1Ca/7xlmuN6QtDRkW7I9NrjlXiAsk278A9km4ZxAyn6CH43+2hiMf7cih/c/I4U6AUt4L5u3ByVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761245049; c=relaxed/simple;
	bh=gN8Ei5rt4bmaCvjM8sTQZrfvvrPAMzvMee7Dk9Rfyts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsaXhTKjr7Yw784vxzEJ3GIh9ZJcZ4OghZy3CK2LK1xmcyq7ELaDUaWtAZSQ6W/yhXt4Yg0RTjDFamZRPBzSJv9R1KtQ9DbbYx2vBIBRhA5i5oBRPa1ZMryNDt0ZdW5w8hXuSsQLh22OGET8QAkWwwSTUSlLbzCGsc1lKFoy3Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AGc6OKjk; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGc6OKjk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761245047; x=1792781047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gN8Ei5rt4bmaCvjM8sTQZrfvvrPAMzvMee7Dk9Rfyts=;
  b=AGc6OKjkwVcac6WjB7nsm2glllR05azvfFsaJn7xhspaHVtl2iR1VPpf
   vHs2QjTaWYZSZpGCi2HdwRvvempbL4ucMC8R9DOZlMp5qh/o+5aoawzQQ
   iVfzjFBGSiV8N45maLLPnkR8bzwd4V37ksegZgh5IOpvUm1nLQo4LdD1D
   WoodosCXcja5k5KZLtSQneejAuDOO2vNjyRMUGdeL1K096akS/MFzqNrJ
   PdB19gY89H0dLhmkbcgGS1Hrtp/Lq9K8XP9PokPnL4k9AQLVFOy0vam4l
   iZQxcAedcZxpodKbNIx90SZw/bYkv6rvwdSbRZSUZWHhkZLtRKNoRJb9s
   g==;
X-CSE-ConnectionGUID: YGhLHsEoRc2ptgkXz2Obeg==
X-CSE-MsgGUID: 4C0aUpZNRRi1WSPSKgiVXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67263484"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67263484"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 11:44:07 -0700
X-CSE-ConnectionGUID: Vls89/knQXOiWpAM2idHgQ==
X-CSE-MsgGUID: 1IKhbpznTLSRkENRjjbEmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="183837864"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.244.163])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 11:44:04 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vC0I5-000000020yV-30Zh;
	Thu, 23 Oct 2025 21:44:01 +0300
Date: Thu, 23 Oct 2025 21:44:01 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify buffer
 initialization
Message-ID: <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
 <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Oct 23, 2025 at 05:35:00PM +0200, Thorsten Blum wrote:
> On 22. Oct 2025, at 20:17, Andy Shevchenko wrote:
> > On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:

...

> How about this?

LGTM, and that's what I had in mind, but please double check the behaviour of
kstrtox() on an empty strings.

> diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> index 18c3e4416dc5..04628dc01456 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> @@ -200,20 +200,12 @@ qat_uclo_cleanup_batch_init_list(struct icp_qat_fw_loader_handle *handle,
>  
>  static int qat_uclo_parse_num(char *str, unsigned int *num)
>  {
> -	char buf[16] = {0};
> -	unsigned long ae = 0;
> -	int i;
> -
> -	strscpy(buf, str, sizeof(buf));
> -	for (i = 0; i < 16; i++) {
> -		if (!isdigit(buf[i])) {
> -			buf[i] = '\0';
> -			break;
> -		}
> -	}
> -	if ((kstrtoul(buf, 10, &ae)))
> -		return -EFAULT;
> +	unsigned long long ae;
> +	char *end;
>  
> +	ae = simple_strtoull(str, &end, 10);
> +	if (ae > UINT_MAX || str == end || (end - str) > 20)

I would go with >= 20, the 64-bit value is approx. 1 * 10^19.

> +		return -EINVAL;
>  	*num = (unsigned int)ae;
>  	return 0;
>  }

-- 
With Best Regards,
Andy Shevchenko


