From: James Hartley <james.hartley-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 0/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Thu, 12 Mar 2015 02:06:50 +0000
Message-ID: <1426126012-16061-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <ezequiel.garcia-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <james.hartley-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
To: <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <abrestic-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
	<smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This adds support for the Imagination Technologies hash accelerator which 
provides hardware acceleration for SHA1 SHA244 SHA256 and MD5 hashes.

Tested on silicon, using testmgr.

Changes from V3:
	* Standardised the cra_priorities to 300, sufficient to be chosen
	  ahead of software / assembly implementations.
	* Addressed Andrew Bresticker's review comments, except for two items
	  that I will leave for when I have some more bandwidth if possible as
	  I don't think they are required:
		->Runtime PM
		->Threaded IRQ handler instead of a tasklet

Changes from V2:
	* This hardware does not support importing a partial hash state, 
	  so the init, update, final and finup have been reworked to use
	  a fallback driver; only digest remains as hardware accelerated.
	* Simplified the driver as a result of the above rework

Changes from V1:
	* Addressed review comments from Andrew Bresticker and 
	  Vladimir Zapolskiy
	* rebased to current linux-next

James Hartley (2):
  This adds support for the Imagination Technologies hash accelerator
    which     provides hardware acceleration for SHA1 SHA224 SHA256 and
    MD5 hashes.
  This adds the binding documentation for the Imagination Technologies
    hash     accelerator that provides hardware acceleration for
    SHA1/SHA224/SHA256/MD5     hashes.  This hardware will be present
    in the upcoming pistachio SoC.

 .../devicetree/bindings/crypto/img-hash.txt        |   27 +
 drivers/crypto/Kconfig                             |   14 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/img-hash.c                          | 1026 ++++++++++++++++++++
 4 files changed, 1068 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt
 create mode 100644 drivers/crypto/img-hash.c

-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
