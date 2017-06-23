From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/7] staging: ccree: register setkey for none hash macs
Date: Sat, 24 Jun 2017 00:29:19 +0800
Message-ID: <20170623162919.GA24336@kroah.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
 <1498138623-6126-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1498138623-6126-3-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 22, 2017 at 04:36:56PM +0300, Gilad Ben-Yossef wrote:
> Fix a bug where the transformation init code did
> not register a setkey method for none hash based MACs.

"none hash based MACs"?  Is that the correct language, I don't
understand it, sorry, can you expand on it a bit in your v3 series?

> Fixes commit 50cfbbb7e627 ("staging: ccree: add ahash support").

This line should be written as:
Fixes: 50cfbbb7e627 ("staging: ccree: add ahash support").

thanks,

greg k-h
