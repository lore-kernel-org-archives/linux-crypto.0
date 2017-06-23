From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/7] staging: ccree: add support for older HW revisions
Date: Sat, 24 Jun 2017 00:30:38 +0800
Message-ID: <20170623163038.GB24336@kroah.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
 <1498138623-6126-4-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1498138623-6126-4-git-send-email-gilad@benyossef.com>
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

On Thu, Jun 22, 2017 at 04:36:57PM +0300, Gilad Ben-Yossef wrote:
> Add support for the older CryptoCell 710 and 630P hardware revisions.

No, I do not want to add new features to staging drivers where ever
possible.  I want you to spend your time fixing up the code to be good
enough to get it out of staging, then you can add any new hardware
support you want to it without having to go back and clean up anything
else.

That is one of the requirements of code in staging, sorry.

thanks,

greg k-h
