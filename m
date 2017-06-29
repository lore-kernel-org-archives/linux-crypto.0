From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Stagingdriver  cctree: Fix for checkpatch warning
Date: Thu, 29 Jun 2017 16:36:10 +0200
Message-ID: <20170629143610.GB6476@kroah.com>
References: <1498544276-5240-1-git-send-email-bincy_k_philip@yahoo.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: bincy_k_philip@yahoo.co.in
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1498544276-5240-1-git-send-email-bincy_k_philip@yahoo.co.in>
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

On Tue, Jun 27, 2017 at 11:47:56AM +0530, bincy_k_philip@yahoo.co.in wrote:
> From: Bincy K Philip <bincy_k_philip@yahoo.co.in>
> 
> Trivial fix for Line over 80 characters
> 
> Moved the comment to top of the definition
> ---
>  drivers/staging/ccree/cc_hw_queue_defs.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)


Always use scripts/checkpatch.pl on your patch so you don't get a grumpy
maintaner telling you to run scripts/checkpatch.pl on your patch :(
