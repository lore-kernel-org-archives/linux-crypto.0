Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129A615DBB6;
	Fri,  7 Jun 2024 11:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761259; cv=none; b=sat5DeIhJ0ql9QWlx9+sSvOOCyHZnuoPTxtUfZtSfyr0c4CR9R0wBoxLhqVz0uN+azdy2vvQCsh68OkfYQtsAMuG39T241+dymdX1eKJOxj0LefjW5gP+2anmA68hB2BkUeyUifpmBz6ZovLbUFcYbgOcnLjt0ld5uStNJ0dVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761259; c=relaxed/simple;
	bh=8Vj+8ez9fmltbd43OiZ5h9ihNvf9f7mYEhWFx4HF7to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHSh7pnmx110Lv0JuyhHVs2axWgPfXS8/BjoCYbgSEC7anNn9tOwpwfeXtqAGEVpxOhgsjYfmWg48Vf6TcRSVU/BJ/wg8jKd7Ffd95enUjyNEwWcZVzXBkQlYs/UAf2B+SKroRh83DnA11zO4BIRF11LvUmUqAM38zEEFqnNHOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYAe-006pBF-37;
	Fri, 07 Jun 2024 19:54:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:54:15 +0800
Date: Fri, 7 Jun 2024 19:54:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mario Limonciello <mario.limonciello@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	"open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..." <linux-crypto@vger.kernel.org>,
	Richard Hughes <hughsient@gmail.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Enable PSP security attributes on more SoCs
Message-ID: <ZmL0556srBSO0cPh@gondor.apana.org.au>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528210712.1268-1-mario.limonciello@amd.com>

On Tue, May 28, 2024 at 04:07:07PM -0500, Mario Limonciello wrote:
> On some older SoCs the PSP doesn't export security attributes in the
> capabilities register.  On these SoCs it is however possible to get
> the information by a platform access command.
> 
> Restructure the driver to move all security attribute handling to
> a central location and then add support for calling the platform
> access command on those processors.
> 
> v1->v2:
>  * Add tags (except patch 2)
>  * Fix kernel robot reported issue
>  * Move a check from patch 4 to patch 5
> Mario Limonciello (5):
>   crypto: ccp: Represent capabilities register as a union
>   crypto: ccp: Move security attributes to their own file
>   crypto: ccp: align psp_platform_access_msg
>   crypto: ccp: Add support for getting security attributes on some older
>     systems
>   crypto: ccp: Move message about TSME being enabled later in init
> 
>  MAINTAINERS                         |   6 ++
>  drivers/crypto/ccp/Makefile         |   3 +-
>  drivers/crypto/ccp/dbc.c            |   2 +-
>  drivers/crypto/ccp/hsti.c           | 138 ++++++++++++++++++++++++++++
>  drivers/crypto/ccp/hsti.h           |  17 ++++
>  drivers/crypto/ccp/psp-dev.c        |  23 ++---
>  drivers/crypto/ccp/psp-dev.h        |  46 +++++-----
>  drivers/crypto/ccp/sp-dev.h         |   2 +-
>  drivers/crypto/ccp/sp-pci.c         |  67 ++------------
>  include/linux/psp-platform-access.h |   5 +-
>  10 files changed, 210 insertions(+), 99 deletions(-)
>  create mode 100644 drivers/crypto/ccp/hsti.c
>  create mode 100644 drivers/crypto/ccp/hsti.h
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
