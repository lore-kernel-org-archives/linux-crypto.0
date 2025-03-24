Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EF425C6E1;
	Mon, 24 Mar 2025 08:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742803649; cv=none; b=p3/yzEBZPzuS0kxOl57nFrhS6T05j7FocU28t8gOymx99uAYmucfhTDlCGP5DQ5ieWJojtfu5mWHzrOYwzfZKLCQT4qzb2MToF8AvvgmN3PvRIfWxDvm7JAkOpVrX3EXtDHrsl9LQS8zItjkGiaA/fG6G+KMQcj06gpymn6Tlzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742803649; c=relaxed/simple;
	bh=5uVL1S6BraAYWpE3iWe+8lb1zkG7XqLBz7/XOL52n9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlxpsqVS3alb8nxICcZzcVk2fGXCuqO4GS7uWSwdslIZr2K9DK9ICqzXjYokfVA8EcWALYUG5j+zE2qngaNxKT+i7VvMQKk4Aj73bjQrmcKzLfonB6aIuAf+8zLNTJcQDHRQxTMZTZ7beWA+BmSP6eBY+0ZQJUHF3FI620qby0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YfW2R0QM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YfW2R0QM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BJnBbXT+Y/QzXSVyatqqvRp8+BKp3EHWB4YBs7jklFQ=; b=YfW2R0QMUlyihJFgNEoDaISCGZ
	4AJQg6134W78eo7XkuL7kpsvhkwGhFtQ8G8FF3NjHCaWp0SdclnOZLzegzDLk7B5vPuHHDW+guh6A
	vtB41BgjYAc6j1sb5juoWp5i1lYmAb5U1xOBJfbRYOVxOjmRTwG2b7nUDHhD0plvntKDSECE6xkDm
	KAZG1h7lNSGUK3Fy0YxknV48ugO5IJiilbYgHugaxvfx16E2LqLqVs0d6lZtjVSdxxZLYBG+fi3od
	RHAHfYcSZalYzoBlDI09zEYjpDFbEfMJ/ouSoVAutz6q/dU0+cJBu3I6hxXN3goZiQ2xWDxFJiTAa
	TPolDWzg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twcqB-009er3-0O;
	Mon, 24 Mar 2025 16:07:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 16:07:23 +0800
Date: Mon, 24 Mar 2025 16:07:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: s390 hmac
Message-ID: <Z-ESu7CyMM873xBB@gondor.apana.org.au>
References: <Z-AJFwndherQBH2W@gondor.apana.org.au>
 <b7bf79e9-9b75-462c-9c25-71dbc708760d@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7bf79e9-9b75-462c-9c25-71dbc708760d@linux.ibm.com>

On Mon, Mar 24, 2025 at 08:50:21AM +0100, Holger Dengler wrote:
>
> The bit s390_kmac_gr0.ikp indicates, if the instruction has processed the inner key padding or not. The bit is zeroed at init() and the first instruction call for a context will set this bit to 1 and update the cv. So, if this bit is 0, the cv in param block contains undefined state.

Thanks for the info!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
