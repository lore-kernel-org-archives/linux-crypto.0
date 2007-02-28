From: Richard Purdie <rpurdie@openedhand.com>
Subject: [PATCH 0/5] Add LZO Compression
Date: Wed, 28 Feb 2007 19:13:18 +0000
Message-ID: <1172689998.16062.135.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, herbert@gondor.apana.org.au
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The following patch series adds LZO compression support to the kernel
and exposes it in a variety of places (jffs2, crypto).

This is particularly useful for jffs2 where significant boot time
speedups (~10%) and file read speed improvements (~40%) are seen when
its used with only a slight drop in file compression ratio.

It also adds a favourlzo mode to jffs2 which is similar to the existing
size mode but lets lzo compression win if the lzo compressed size is
"similar" to but not the best compression ratio. This means we can keep
zlib compression where it makes a significant difference to compressed
file size.

The final jffs2 patch which starts adding sysfs support is something I
have around from testing and I'm including it for comments to see if its
desirable upstream. It could be extended further to allow greater
control of jffs2 at runtime.

Richard






______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
