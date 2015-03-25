From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] arm: crypto: Add NEON optimized SHA-256
Date: Wed, 25 Mar 2015 21:00:38 +0100
Message-ID: <20150325200038.GM14457@ns203013.ovh.net>
References: <20150316154835.GA31336@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 ard.biesheuvel@linaro.org
To: Sami Tolvanen <samitolvanen@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20150316154835.GA31336@google.com>
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

On 15:48 Mon 16 Mar     , Sami Tolvanen wrote:
> Add Andy Polyakov's NEON optimized SHA-256 implementation.
> 
> On Nexus 6, this implementation is ~2x faster than sha256-generic.

do you plan to add the sha512 from openssl too?

Whould be nice so armv4 can get faster implementatio too

Best Regards,
J.
