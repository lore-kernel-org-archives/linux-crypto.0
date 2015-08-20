From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v1 1/4] dmaengine: Add support for new feature CRC32C
Date: Thu, 20 Aug 2015 12:38:49 +0530
Message-ID: <20150820070849.GF13546@localhost>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
 <1438258268-3099-2-git-send-email-rsahu@apm.com>
 <20150820052631.GW13546@localhost>
 <CAFd313x+MD5C2stJ-YdKrt6Ywzt4_2GmK3pJTFjfwrhPnCdopQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.j.williams@intel.com, Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com
To: Rameshwar Sahu <rsahu@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:5822 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbbHTHGq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:06:46 -0400
Content-Disposition: inline
In-Reply-To: <CAFd313x+MD5C2stJ-YdKrt6Ywzt4_2GmK3pJTFjfwrhPnCdopQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 11:59:07AM +0530, Rameshwar Sahu wrote:
> Hi Vinod,
> 
> On Thu, Aug 20, 2015 at 10:56 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Thu, Jul 30, 2015 at 05:41:05PM +0530, Rameshwar Prasad Sahu wrote:
> >> This patch adds support for new feature CRC32C calculation in
> >> dmaengine framework.
> >
> > Looks okay can you please update Documentation also
> 
> Thanks, I will update Documentation.

Also add a wrapper for new API

-- 
~Vinod
