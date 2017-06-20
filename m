From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 01/11] Fix coding style of
 driver/staging/ccree/ssi_aead.c ERROR: space required after that
Date: Tue, 20 Jun 2017 11:20:15 +0300
Message-ID: <20170620082015.c2gyluuhlvcah532@mwanda>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Jhih-Ming Huang <fbihjmeric@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
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

Subject is wrong.  It should be:

[PATCH 1/11] Staging: ccree: add spaces blah blah blah

On Tue, Jun 20, 2017 at 01:19:44PM +0800, Jhih-Ming Huang wrote:
> From: Jhih-Ming Hunag <fbihjmeric@gmail.com>
> 

No need.

> In this series patches, I fix all of the coding style error in 
> driver/staging/ccree/ssi_aead.c from 54 errors to 0 error.

You could put this into the cover letter.  When we put this into the
final git log we don't see the series only individual patches.

> 
> The first patch fixed 'ERROR: space required after that'.
> 

This patch fixes ...

regards,
dan carpenter
