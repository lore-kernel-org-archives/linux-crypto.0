From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/4] crypto: [sha] glue code for Intel SHA extensions
 optimized SHA1 & SHA256
Date: Fri, 11 Sep 2015 12:15:09 -0700 (PDT)
Message-ID: <20150911.121509.844598934515668336.davem@davemloft.net>
References: <1441929871.4322.15.camel@schen9-desk2.jf.intel.com>
	<1671234.vBOzL28The@tauon.atsec.com>
	<1441997372.4322.37.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, hpa@zytor.com,
	sean.m.gulley@intel.com, mouli_7982@yahoo.com,
	vinodh.gopal@intel.com, james.guilford@intel.com,
	wajdi.k.feghali@intel.com, jussi.kivilinna@iki.fi,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: tim.c.chen@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49797 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbIKTPM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Sep 2015 15:15:12 -0400
In-Reply-To: <1441997372.4322.37.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Fri, 11 Sep 2015 11:49:32 -0700

> Still, why would some kernel module specifically not want to 
> use the fastest HW implementation, and explicitly ask for
> a slower driver?

Temporary workaround if a bug is found.

There is really no reason to prevent the user from having this
flexibility, and in return anyone can test any implementation
their cpu can support.
