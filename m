From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 02/10] crypto: marvell: Check engine is not already
 running when enabling a req
Date: Wed, 22 Jun 2016 18:33:24 +0800
Message-ID: <20160622103324.GA30918@gondor.apana.org.au>
References: <1466496520-28806-3-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: thomas.petazzoni@free-electrons.com, boris.brezillon@free-electrons.com,
 linux@arm.linux.org.uk, arno@natisbad.org, linux-crypto@vger.kernel.org,
 gregory.clement@free-electrons.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1466496520-28806-3-git-send-email-romain.perier@free-electrons.com>
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

Romain Perier <romain.perier@free-electrons.com> wrote:
> Add a BUG_ON() call when the driver tries to launch a crypto request
> while the engine is still processing the previous one. This replaces
> a silent system hang by a verbose kernel panic with the associated
> backtrace to let the user know that something went wrong in the CESA
> driver.

Hmm, so how can this happen? If it is triggerable then we better
try to recover from it more gracefully.  If it is not triggerable
then why bother?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
