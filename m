From: James Morris <jmorris@namei.org>
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
Date: Tue, 16 Aug 2011 10:57:36 +1000 (EST)
Message-ID: <alpine.LRH.2.00.1108161056310.7706@tundra.namei.org>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:35342 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HPA5j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2011 20:57:39 -0400
In-Reply-To: <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:

> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> 
> Adds the multi-precision-integer maths library which was originally taken
> from GnuPG and ported to the kernel by (among others) David Howells.
> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.

First thing -- this code needs to be formatted using kernel coding style.


- James
-- 
James Morris
<jmorris@namei.org>
