From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC v2 PATCH 0/9] Add IPsec extended (64-bit) sequence numbers
Date: Tue, 8 Mar 2011 11:04:07 +0100
Message-ID: <20110308100407.GB31402@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Badea <abadea@ixiacom.com>,
	Andreas Gruenbacher <agruen@suse.de>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset adds support for IPsec extended (64-bit) sequence numbers for
esp as defined in RFC 4303. Also it adds support for anti-replay windows
bigger than 32 packets. To make use of big anti-replay windows and extended
sequence numbers, new userspace tools are needed. An example patch for
iproute2 is provided with this patchset.

Known issues:

-  Not tested against another implementation of IPsec extended
   sequence numbers.

Changes from v1:

-  Use a SG list with three 4 byte entries for the associated data.

-  Fix the sequence number to be in network byte order when using AEAD
   algorithms.

-  Rebased to net-next-2.6 current.

The patchset is also available at branch 'net-next-esn' of

git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-2.6-stk.git

Steffen
