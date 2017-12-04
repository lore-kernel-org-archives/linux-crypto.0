From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] treewide: remove duplicate includes
Date: Mon, 4 Dec 2017 10:27:31 -0800
Message-ID: <20171204182731.GA4903@magnolia>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org,
 sstabellini@kernel.org, gregkh@linuxfoundation.org, x86@kernel.org,
 ast@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 mcgrof@kernel.org, mhiramat@kernel.org, linux-kselftest@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, namhyung@kernel.org, mchehab@kernel.org,
 shuah@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
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

On Mon, Dec 04, 2017 at 03:19:39AM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Unit Testing:
> 
> - build successful
> - LTP testsuite passes.
> - checkpatch.pl passes
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

<supersnip>

> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 9c42c4e..ab3aef2 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c

These look reasonable, but please send me (and linux-xfs) the three
xfs changes separately so that I can add them to the xfs tree.

(Also, thank you for cc'ing the xfs list for this treewide change...)

--D
