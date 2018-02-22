From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: bcm2835: Handle deferred clock properly
Date: Thu, 22 Feb 2018 23:11:49 +0800
Message-ID: <20180222151149.GD29815@gondor.apana.org.au>
References: <1518466296-30161-1-git-send-email-stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 Scott Branden <sbranden@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Jon Mason <jonmason@broadcom.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Matt Mackall <mpm@selenic.com>, Eric Anholt <eric@anholt.net>,
 bcm-kernel-feedback-list@broadcom.com, linux-crypto@vger.kernel.org,
 Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org
To: Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1518466296-30161-1-git-send-email-stefan.wahren@i2se.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 12, 2018 at 09:11:36PM +0100, Stefan Wahren wrote:
> In case the probe of the clock is deferred, we would assume it is
> optional. This is wrong, so defer the probe of this driver until
> the clock is available.
> 
> Fixes: 791af4f4907a ("hwrng: bcm2835 - Manage an optional clock")
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
