From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] MPILIB: avoid assembler warning
Date: Wed, 28 Jan 2015 16:42:27 +0000
Message-ID: <9572.1422463347@warthog.procyon.org.uk>
References: <16372019.BFlLRod3Eu@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 dhowells@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
 linux-crypto@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <16372019.BFlLRod3Eu@wuerfel>
Content-ID: <9571.1422463347.1@warthog.procyon.org.uk>
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

Arnd Bergmann <arnd@arndb.de> wrote:

> Not sure who would be the best person to pick this patch up.

I can pick it up, but I wonder if the MPI asm bits should be distributed to
asm/mpilib.h headers rather than being in the lib/ directory.

David
