Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4590B1A9FB7;
	Sat, 18 Apr 2026 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776473648; cv=none; b=kI86N2GRIoS/v5aMMN7hmhyUcs9axr7ChXtWgVzhmL5tFtHaShxtPJ+2KEuHhRCd+bQrPopU0D2qXZkwAOs0hV2Hgxbcv+NV+/fU0TlnF8iq2BXaHeu2G6y5ibn+vuBdY9AqfrdBI0rptgPnsfw4Na2lIBgM6nYIDyfoCdpnpIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776473648; c=relaxed/simple;
	bh=Eh4YKOEQxUkzYLTuk454U/mtIYmRHYZY0hL416z/FvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqSa0KywQm5G+PABbx2poswSoMhrg7dsU7qafd4HPiEYAcRkRichm5O3b3SB2DJ3usNIXh8ZG6xL59n48HTH14PgMVFSW7zbO+6fpeXkO2SHF6TpsmXR7qfMEXUR7Z1eVnXAM/UPrXqgI+Nsrm4bp+4m729xBJjSEjDjk8NaZNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sSZhRvLc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sSZhRvLc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7Vw25T2IgCy2UdrbOQu27xjC1sEtUFLERZinvOOi+J4=; 
	b=sSZhRvLco4+/r14cixKPIzTfTg/SehURvaVoh6QlG6o5uzOvfWj19J6aPnXROOKPX0q2Dp/kEVS
	ge19aq4G6K0cbJxXCQ/GjvmN23euJQfuC90vxb6OgjM5ZfGfuAHyc6LOy5kKbJgIhAYPiU9I89nWc
	SypI6+U90ODlugBCQrd084JT2VRrSNlYSDjmrwydyFZw72HfGm648acgqXBON+SlSjalZ39rF60RG
	QFy+P1qvj8ZK/UETMq5j92ztxPk6K0esDbwLr0BYrtpLowNS3iz8l0rIvCt/yWNaE0glcSGsaqzNG
	1ZVp5jrvePm4MR2Cx3s0P/Tjb9BU59zZSGbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDtwV-006vuL-2B;
	Sat, 18 Apr 2026 08:53:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 18 Apr 2026 08:53:51 +0800
Date: Sat, 18 Apr 2026 08:53:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeLWH_HgSHF4buiJ@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
 <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
 <aeLT8eB_xfzLxqbI@gondor.apana.org.au>
 <aeLV6aDhM0-S4oQ1@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeLV6aDhM0-S4oQ1@slm.duckdns.org>

On Fri, Apr 17, 2026 at 02:52:57PM -1000, Tejun Heo wrote:
>
> I see. Thanks, that should work. How should we go about reverting the
> removal?

I'll work on that today and then you can include it in your
two-patch series.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
