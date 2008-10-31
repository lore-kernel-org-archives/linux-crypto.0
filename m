From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: IPsec books and how to add async hardware encryption ?
Date: Fri, 31 Oct 2008 23:32:51 +0300
Message-ID: <20081031203251.GC32720@ioremap.net>
References: <200810311508.48703.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dean Jenkins <djenkins@mvista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:51158 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYJaUcy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2008 16:32:54 -0400
Content-Disposition: inline
In-Reply-To: <200810311508.48703.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Oct 31, 2008 at 03:08:48PM +0000, Dean Jenkins (djenkins@mvista.com) wrote:
> I am having difficulty finding a book that describes IPsec that includes IKEv2 
> and is preferably aimed at using Linux crypto. Can anyone recommend such a 
> book ?

There is no such book I believe.

> Also, how do I find info on the cypto APIs eg. how to use cryptd (2.6.24 
> kernel) ?
> 
> I'm working on a project that uses an embedded hardware encryption engine that 
> needs to use async off-load. Is cryptd the entity for async hardware crypto 
> off-loading ?

cryptd is an software engine example of how hardware driver could be implemented.

-- 
	Evgeniy Polyakov
