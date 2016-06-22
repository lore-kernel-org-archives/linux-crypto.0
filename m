From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH v3 02/10] crypto: marvell: Check engine is not already
 running when enabling a req
Date: Wed, 22 Jun 2016 13:23:39 +0200
Message-ID: <576A753B.7070507@free-electrons.com>
References: <20160622103324.GA30918@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Cc: thomas.petazzoni@free-electrons.com, boris.brezillon@free-electrons.com,
 linux@arm.linux.org.uk, arno@natisbad.org, linux-crypto@vger.kernel.org,
 gregory.clement@free-electrons.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160622103324.GA30918@gondor.apana.org.au>
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

Hello,

Le 22/06/2016 12:33, Herbert Xu a =E9crit :
> Romain Perier <romain.perier@free-electrons.com> wrote:
>> Add a BUG_ON() call when the driver tries to launch a crypto request
>> while the engine is still processing the previous one. This replaces
>> a silent system hang by a verbose kernel panic with the associated
>> backtrace to let the user know that something went wrong in the CESA
>> driver.
>
> Hmm, so how can this happen?
If it is triggerable then we better
> try to recover from it more gracefully.  If it is not triggerable
> then why bother?
>

Well, It does not happen with the current driver (in mainline). This is =

bug I had when I added support to chain requests. Take a look at the =

patch 008/010, it changes the way the requests are "prepared". If you =

really enable a request while the engine is running, that's very hard to =

debug. This is more useful to have a backtrace to let the user know that =

something is wrong instead of having a silent system hang. That's easier =

to debug and you can detect regressions.

Regards,
Romain
-- =

Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
