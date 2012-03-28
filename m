From: Dale Amon <amon@vnl.com>
Subject: Status of aes in Debian/Ubuntu?
Date: Wed, 28 Mar 2012 13:17:45 +0100
Message-ID: <20120328121744.GY32725@vnl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: amon@vnl.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grendel.xisp.net ([96.255.255.193]:49602 "EHLO ba-blue.xisp.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637Ab2C1NBJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 09:01:09 -0400
Received: from otv2 (cpc6-glen4-2-0-cust217.2-1.cable.virginmedia.com [80.4.162.218])
	by ba-blue.xisp.net (8.13.8/8.13.8) with ESMTP id q2SCr7iN009252
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Wed, 28 Mar 2012 08:53:09 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Been away from the list for awhile and you went
and moved the list on me!

Yesterday I pulled out my notes from the last time
I set up a crypto disk and found that basically,
nothing worked.

The losetup lists all the appropriate crypto types
in its Man page but when I try to actually use AES256,
it throws a fit. When I look in modules for the
current kernel, I do not see a module for aes at all.

I might also note that I was surprised to find the -k
switch for specifying key size is gone.

I tried downloading a package with aes in it, but it
turns out to require local build. So... I tried that.

I discovered that the module failed to declare kpkg
as a prerequisite. I eventually figured that error out
and selected it manually.

And then I tried everything I could think of short of
going 'all the way in': I tried module-assistant; I
tried m-a; I tried the commands from the INSTALL file
one at a time. All of them failed.

This is just SOOooo 1999... aren't things supposed to
get better with time? ;-)

I would be happy to supply any information required
or to run a few tests in between other work. Test 
server is an ancient (perhaps 2003) box with Ubuntu
Oneiric, fully up to date.

If I want to use something like this for a production
environment, it has to be solid and update and work
forever into the future. 
