From: Richard Purdie <rpurdie@openedhand.com>
Subject: [PATCH 0/5] Add LZO Compression
Date: Tue, 01 May 2007 15:46:34 +0100
Message-ID: <1178030794.5883.50.camel@localhost.localdomain>
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

Its a resend of a previous posted series, rediffed against recent
kernels with the couple of minors issues raised by David Woodhouse
addressed.

This patch series is also available as:
git://git.o-hand.com/linux-rpurdie linux-rpurdie-lzo
(http://git.o-hand.com/?p=linux-rpurdie;a=shortlog;h=linux-rpurdie-lzo)

LZO compression is particularly useful for jffs2 where significant boot
time speedups (~10%) and file read speed improvements (~40%) are seen
when its used with only a slight drop in file compression ratio.

It also adds a favourlzo mode to jffs2 which is similar to the existing
size mode but lets lzo compression win if the lzo compressed size is
"similar" to but not the best compression ratio. This means we can keep
zlib compression where it makes a significant difference to compressed
file size.

The final jffs2 patch which starts adding sysfs support for control of
jffs2 options at runtime that are currently available only at boottime.
There are several other controls which it may be desirable to add to the
basic framework this patch creates in due course.

Richard



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
