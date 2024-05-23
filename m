Received: from xmailer.gwdg.de (xmailer.gwdg.de [134.76.10.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095261EA74;
	Thu, 23 May 2024 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474928; cv=none; b=abLdKV2ij0Pwfexy0cS3/WggqlAYTpHaTe4VaSoBbJEGYtJDS2UXkT60JomI+pZOkUDlMsAZukj5JHak20wwidQHlDLHwnNIXlVu4UlZ9tiV5Jder5yYP1CM+CA3aZk1nREx/JH9zjK6IbIudXbeQbq4Gkddc2b2JKX9xKxh8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474928; c=relaxed/simple;
	bh=DqNAaMwLUQKqQeSpUg1T7UK/osvQjYsNfnoBau1Fld0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmdDSy3SvLdRCLwaz3gksYbrGnFdyw7NLXS2Cln4F0yBetiNQrTZLkJNyuc6WfpioJ/J369f57Udpa0DofGXpps0EH7BjJohhK2FeORCU+BAXXqLw/shy3aqKQLnWVtTF0kIQv8mc2T5ElpyEiKeMOD7KH92U5cWnmo+l7GRlbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de; spf=pass smtp.mailfrom=tuebingen.mpg.de; arc=none smtp.client-ip=134.76.10.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuebingen.mpg.de
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <maan@tuebingen.mpg.de>)
	id 1sA9Fd-000Fu8-1x;
	Thu, 23 May 2024 16:17:01 +0200
Received: from [10.35.40.80] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 52279345; Thu, 23 May 2024 16:17:00 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Thu, 23 May 2024 16:17:00 +0200
Date: Thu, 23 May 2024 16:17:00 +0200
From: Andre Noll <maan@tuebingen.mpg.de>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	Andre Noll <maan@systemlinux.org>, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] docs: crypto: async-tx-api: fix broken code example
Message-ID: <Zk9P3ITcqc-9EhZp@tuebingen.mpg.de>
References: <20240523-async-dma-docs-v1-1-b900e0804e11@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240523-async-dma-docs-v1-1-b900e0804e11@pengutronix.de>
User-Agent: Mutt/2.2.13 (00d56288) (2024-03-09)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav

On Thu, May 23, 15:18, Ahmad Fatoum wrote
> The code example fails to compile:
> 
>   1) ddr_conv is defined twice, once as a VLA, which have been phased out

       addr_conv
> 
>   2) submit is not a pointer, but is still dereferenced with ->

3) The first call to async_xor() lacked the trailing semicolon.

> Fix these issues and while at it, make the functions static as users
> are unlikely to export them.

No objections, but please don't consider me authoritative. Two nits
below, FWIW.

> --- a/Documentation/crypto/async-tx-api.rst
> +++ b/Documentation/crypto/async-tx-api.rst
> @@ -150,38 +150,38 @@ of an operation.
>  Perform a xor->copy->xor operation where each operation depends on the
>  result from the previous operation::

Maybe add

#include <linux/async_tx.h>

>  
> -    void callback(void *param)
> +    static void callback(void *param)
>      {
>  	    struct completion *cmp = param;
>  
>  	    complete(cmp);
>      }

This could be simplified to

static void callback(void *param)
{
	complete(param);
}

Best
Andre
-- 
Max Planck Institute for Biology
Tel: (+49) 7071 601 829
Max-Planck-Ring 5, 72076 Tübingen, Germany
http://people.tuebingen.mpg.de/maan/
