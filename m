From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 5/7] staging: ccree: add clock management support
Date: Sat, 24 Jun 2017 00:31:13 +0800
Message-ID: <20170623163113.GC24336@kroah.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
 <1498138623-6126-6-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1498138623-6126-6-git-send-email-gilad@benyossef.com>
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

On Thu, Jun 22, 2017 at 04:36:59PM +0300, Gilad Ben-Yossef wrote:
> Some SoC which implement CryptoCell have a dedicated clock
> tied to it, some do not. Implement clock support if exists
> based on device tree data and tie power management to it.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/Makefile     |  2 +-
>  drivers/staging/ccree/ssi_driver.c | 40 +++++++++++++++++++++----
>  drivers/staging/ccree/ssi_driver.h |  4 +++
>  drivers/staging/ccree/ssi_pm.c     | 13 +++++----
>  drivers/staging/ccree/ssi_pm_ext.c | 60 --------------------------------------
>  drivers/staging/ccree/ssi_pm_ext.h | 33 ---------------------
>  6 files changed, 47 insertions(+), 105 deletions(-)
>  delete mode 100644 drivers/staging/ccree/ssi_pm_ext.c
>  delete mode 100644 drivers/staging/ccree/ssi_pm_ext.h

Ok, adding new features that make the code smaller is ok, this is nice :)
