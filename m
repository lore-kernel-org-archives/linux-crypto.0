From: Richard Purdie <rpurdie@openedhand.com>
Subject: [PATCH 0/5] Add LZO Compression
Date: Fri, 04 May 2007 12:30:39 +0100
Message-ID: <1178278239.5839.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Satyam Sharma <satyam.sharma@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:47109 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXEDLax (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 May 2007 07:30:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The following patch series adds LZO compression support to the kernel
and exposes it in a variety of places (jffs2, crypto).

Its a resend of a previous posted series with the comments from Randy
Dunlap and Satyam Sharma taken into account. Patch 1/5 is unchanged and
large so will not be resent.

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
