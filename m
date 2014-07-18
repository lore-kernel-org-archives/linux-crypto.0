From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 9/9] crypto: caam - add Run Time Library (RTA) docbook
Date: Fri, 18 Jul 2014 19:37:26 +0300
Message-ID: <1405701446-13656-10-git-send-email-horia.geanta@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>,
	Randy Dunlap <rdunlap@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:25091
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756997AbaGRQjf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:39:35 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add SGML template for generating RTA docbook.
Source code is in drivers/crypto/caam/flib

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 Documentation/DocBook/Makefile         |   3 +-
 Documentation/DocBook/rta-api.tmpl     | 245 +++++++++++++++++++++
 Documentation/DocBook/rta/.gitignore   |   1 +
 Documentation/DocBook/rta/Makefile     |   5 +
 Documentation/DocBook/rta/rta_arch.svg | 381 +++++++++++++++++++++++++++++++++
 5 files changed, 634 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/DocBook/rta-api.tmpl
 create mode 100644 Documentation/DocBook/rta/.gitignore
 create mode 100644 Documentation/DocBook/rta/Makefile
 create mode 100644 Documentation/DocBook/rta/rta_arch.svg

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index bec06659e0eb..f2917495db49 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -15,7 +15,7 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
 	    tracepoint.xml drm.xml media_api.xml w1.xml \
-	    writing_musb_glue_layer.xml
+	    writing_musb_glue_layer.xml rta-api.xml
 
 include Documentation/DocBook/media/Makefile
 
@@ -53,6 +53,7 @@ htmldocs: $(HTML)
 	$(call build_main_index)
 	$(call build_images)
 	$(call install_media_images)
+	$(call install_rta_images)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
diff --git a/Documentation/DocBook/rta-api.tmpl b/Documentation/DocBook/rta-api.tmpl
new file mode 100644
index 000000000000..cefd267a00eb
--- /dev/null
+++ b/Documentation/DocBook/rta-api.tmpl
@@ -0,0 +1,245 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+        "http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="RTAapi">
+ <bookinfo>
+  <title>Writing descriptors for Freescale CAAM using RTA library</title>
+  <authorgroup>
+   <author>
+    <firstname>Horia</firstname>
+    <surname>Geanta</surname>
+    <affiliation>
+     <address><email>horia.geanta@freescale.com</email></address>
+    </affiliation>
+   </author>
+  </authorgroup>
+
+  <copyright>
+   <year>2008-2014</year>
+   <holder>Freescale Semiconductor</holder>
+  </copyright>
+
+  <legalnotice>
+   <para>
+     This documentation is free software; you can redistribute
+     it and/or modify it under the terms of the GNU General Public
+     License as published by the Free Software Foundation; either
+     version 2 of the License, or (at your option) any later
+     version.
+   </para>
+
+   <para>
+     This program is distributed in the hope that it will be
+     useful, but WITHOUT ANY WARRANTY; without even the implied
+     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+     See the GNU General Public License for more details.
+   </para>
+
+   <para>
+     For more details see the file COPYING in the source
+     distribution of Linux.
+   </para>
+  </legalnotice>
+ </bookinfo>
+
+<toc></toc>
+
+  <chapter id="intro">
+    <title>Introduction</title>
+    <sect1>
+      <title>About</title>
+!Pdrivers/crypto/caam/flib/rta.h About
+!Pdrivers/crypto/caam/flib/rta.h Usage
+      <mediaobject>
+        <imageobject>
+          <imagedata fileref="rta_arch.svg" format="SVG" align="CENTER"/>
+        </imageobject>
+        <caption><para>RTA Integration Overview</para></caption>
+      </mediaobject>
+    </sect1>
+    <sect1>
+      <title>Using RTA</title>
+      <para>
+        RTA can be used in an application just by including the following header file:
+	#include flib/rta.h
+      </para>
+      <para>
+        The files in drivers/crypto/caam/desc directory contain several
+	real-world descriptors written with RTA. You can use them as-is or adapt
+	them to your needs.
+      </para>
+      <para>
+        RTA routines assume that your code defines a local variable named
+	"program":
+	<itemizedlist mark='opencircle'>
+	  <listitem>
+	    <para>struct program prg;</para>
+	  </listitem>
+	  <listitem>
+	    <para>struct program *program = &amp;prg;</para>
+	  </listitem>
+	</itemizedlist>
+        This variable is passed behind the scene to all RTA API calls.
+	It contains several housekeeping information that are used during
+	descriptor creation.
+      </para>
+      <para>
+        RTA creates the descriptors and saves them in buffers. It is the user's
+	job to allocate memory for these buffers before passing them to RTA
+	program initialization call.
+      </para>
+      <para>
+        A RTA program must start with a call to PROGRAM_CNTXT_INIT and end with
+	PROGRAM_FINALIZE. PROGRAM_CNTXT_INIT will initialze the members of
+	'program' structure with user information (pointer to user's buffer, and
+	the SEC subversion). The PROGRAM_FINALIZE call checks the descriptor's
+	validity.
+      </para>
+      <para>
+        The program length is limited to the size of buffer descriptor which
+	can be maximum 64 words (256 bytes). However, a JUMP command can cause
+	loading and execution of another Job Descriptor; this allows for much
+	larger programs to be created.
+      </para>
+    </sect1>
+    <sect1>
+      <title>RTA components</title>
+      <para>
+        The content of the package is split mainly in two components:
+	<itemizedlist mark='opencircle'>
+	  <listitem>
+	    <para>descriptor builder API (drivers/crypto/caam/flib/rta.h)</para>
+	  </listitem>
+	  <listitem>
+	    <para>
+	      ready to use RTA descriptors
+	      (drivers/crypto/caam/flib/desc/*.h)
+	    </para>
+	  </listitem>
+	</itemizedlist>
+      </para>
+      <para>
+        These are the main building blocks of descriptors:
+	<itemizedlist mark='opencircle'>
+	  <listitem>
+	    <para>buffer management: init &amp; finalize</para>
+	  </listitem>
+	  <listitem>
+	    <para>SEC commands: MOVE, LOAD, FIFO_LOAD etc.</para>
+	  </listitem>
+	  <listitem>
+	    <para>descriptor labels (e.g. used as JUMP destinations)</para>
+	  </listitem>
+	  <listitem>
+	    <para>
+	      utility commands: (e.g. PATCH_* commands that update labels and
+	      references)
+	    </para>
+	  </listitem>
+	</itemizedlist>
+      </para>
+      <para>
+        In some cases, descriptor fields can't all be set when the commands are
+	inserted. These fields must be updated in a similar fashion to what the
+	linking process does with a binary file. RTA uses PATCH_* commands to
+	get relevant information and PROGRAM_FINALIZE to complete the
+	"code relocation".
+      </para>
+      <para>
+        If there is a need for descriptors larger than 64 words, their function
+	can be split into several smaller ones. In such case the smaller
+	descriptors are correlated and updated using PATCH_*_NON_LOCAL commands.
+	These calls must appear after all the descriptors are finalized and not
+	before as in a single descriptor case (the reason being that only then
+	references to all descriptors are available).
+      </para>
+    </sect1>
+  </chapter>
+
+  <chapter id="apiref">
+    <title>RTA API reference</title>
+    <sect1>
+      <title>Descriptor Buffer Management Routines</title>
+!Pdrivers/crypto/caam/flib/rta.h Descriptor Buffer Management Routines
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h rta_sec_era
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h USER_SEC_ERA
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h INTL_SEC_ERA
+!Fdrivers/crypto/caam/flib/rta.h PROGRAM_CNTXT_INIT
+!Fdrivers/crypto/caam/flib/rta.h PROGRAM_FINALIZE
+!Fdrivers/crypto/caam/flib/rta.h PROGRAM_SET_36BIT_ADDR
+!Fdrivers/crypto/caam/flib/rta.h PROGRAM_SET_BSWAP
+!Fdrivers/crypto/caam/flib/rta.h WORD
+!Fdrivers/crypto/caam/flib/rta.h DWORD
+!Fdrivers/crypto/caam/flib/rta.h COPY_DATA
+!Fdrivers/crypto/caam/flib/rta.h DESC_LEN
+!Fdrivers/crypto/caam/flib/rta.h DESC_BYTES
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h program
+    </sect1>
+    <sect1>
+      <title>SEC Commands Routines</title>
+!Pdrivers/crypto/caam/flib/rta.h SEC Commands Routines
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h rta_share_type
+!Fdrivers/crypto/caam/flib/rta.h SHR_HDR
+!Fdrivers/crypto/caam/flib/rta.h JOB_HDR
+!Fdrivers/crypto/caam/flib/rta.h JOB_HDR_EXT
+!Fdrivers/crypto/caam/flib/rta.h MOVE
+!Fdrivers/crypto/caam/flib/rta.h MOVEB
+!Fdrivers/crypto/caam/flib/rta.h MOVEDW
+!Fdrivers/crypto/caam/flib/rta.h FIFOLOAD
+!Fdrivers/crypto/caam/flib/rta.h SEQFIFOLOAD
+!Fdrivers/crypto/caam/flib/rta.h FIFOSTORE
+!Fdrivers/crypto/caam/flib/rta.h SEQFIFOSTORE
+!Fdrivers/crypto/caam/flib/rta.h KEY
+!Fdrivers/crypto/caam/flib/rta.h SEQINPTR
+!Fdrivers/crypto/caam/flib/rta.h SEQOUTPTR
+!Fdrivers/crypto/caam/flib/rta.h ALG_OPERATION
+!Fdrivers/crypto/caam/flib/rta.h PROTOCOL
+!Fdrivers/crypto/caam/flib/rta.h PKHA_OPERATION
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h rta_jump_cond
+!Fdrivers/crypto/caam/flib/rta/sec_run_time_asm.h rta_jump_type
+!Fdrivers/crypto/caam/flib/rta.h JUMP
+!Fdrivers/crypto/caam/flib/rta.h JUMP_INC
+!Fdrivers/crypto/caam/flib/rta.h JUMP_DEC
+!Fdrivers/crypto/caam/flib/rta.h LOAD
+!Fdrivers/crypto/caam/flib/rta.h SEQLOAD
+!Fdrivers/crypto/caam/flib/rta.h STORE
+!Fdrivers/crypto/caam/flib/rta.h SEQSTORE
+!Fdrivers/crypto/caam/flib/rta.h MATHB
+!Fdrivers/crypto/caam/flib/rta.h MATHU
+!Fdrivers/crypto/caam/flib/rta.h SIGNATURE
+!Fdrivers/crypto/caam/flib/rta.h NFIFOADD
+    </sect1>
+    <sect1>
+      <title>Self Referential Code Management Routines</title>
+!Pdrivers/crypto/caam/flib/rta.h Self Referential Code Management Routines
+!Fdrivers/crypto/caam/flib/rta.h REFERENCE
+!Fdrivers/crypto/caam/flib/rta.h LABEL
+!Fdrivers/crypto/caam/flib/rta.h SET_LABEL
+!Fdrivers/crypto/caam/flib/rta.h PATCH_JUMP
+!Fdrivers/crypto/caam/flib/rta.h PATCH_JUMP_NON_LOCAL
+!Fdrivers/crypto/caam/flib/rta.h PATCH_MOVE
+!Fdrivers/crypto/caam/flib/rta.h PATCH_MOVE_NON_LOCAL
+!Fdrivers/crypto/caam/flib/rta.h PATCH_LOAD
+!Fdrivers/crypto/caam/flib/rta.h PATCH_STORE
+!Fdrivers/crypto/caam/flib/rta.h PATCH_STORE_NON_LOCAL
+!Fdrivers/crypto/caam/flib/rta.h PATCH_RAW
+!Fdrivers/crypto/caam/flib/rta.h PATCH_RAW_NON_LOCAL
+    </sect1>
+  </chapter>
+
+  <chapter id="descapi">
+    <title>RTA descriptors library</title>
+    <sect1>
+      <title>Job Descriptor Example Routines</title>
+!Pdrivers/crypto/caam/flib/desc/jobdesc.h Job Descriptor Constructors
+!Fdrivers/crypto/caam/flib/desc/jobdesc.h cnstr_jobdesc_mdsplitkey
+    </sect1>
+    <sect1>
+      <title>Auxiliary Data Structures</title>
+!Pdrivers/crypto/caam/flib/desc/common.h Shared Descriptor Constructors - shared structures
+!Fdrivers/crypto/caam/flib/desc/common.h alginfo
+!Fdrivers/crypto/caam/flib/desc/common.h protcmd
+    </sect1>
+  </chapter>
+</book>
diff --git a/Documentation/DocBook/rta/.gitignore b/Documentation/DocBook/rta/.gitignore
new file mode 100644
index 000000000000..e461c585fde8
--- /dev/null
+++ b/Documentation/DocBook/rta/.gitignore
@@ -0,0 +1 @@
+!*.svg
diff --git a/Documentation/DocBook/rta/Makefile b/Documentation/DocBook/rta/Makefile
new file mode 100644
index 000000000000..58981e3ae3ef
--- /dev/null
+++ b/Documentation/DocBook/rta/Makefile
@@ -0,0 +1,5 @@
+RTA_OBJ_DIR=$(objtree)/Documentation/DocBook/
+RTA_SRC_DIR=$(srctree)/Documentation/DocBook/rta
+
+install_rta_images = \
+        $(Q)cp $(RTA_SRC_DIR)/*.svg $(RTA_OBJ_DIR)/rta_api
diff --git a/Documentation/DocBook/rta/rta_arch.svg b/Documentation/DocBook/rta/rta_arch.svg
new file mode 100644
index 000000000000..d816eed04852
--- /dev/null
+++ b/Documentation/DocBook/rta/rta_arch.svg
@@ -0,0 +1,381 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!-- Created with Inkscape (http://www.inkscape.org/) -->
+
+<svg
+   xmlns:dc="http://purl.org/dc/elements/1.1/"
+   xmlns:cc="http://creativecommons.org/ns#"
+   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
+   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
+   width="644.09448819"
+   height="652.3622047"
+   id="svg2"
+   version="1.1"
+   inkscape:version="0.48.2 r9819"
+   sodipodi:docname="rta_arch.svg"
+   inkscape:export-filename="Z:\repos\sdk-devel\flib\sec\rta\doc\images\rta_arch.png"
+   inkscape:export-xdpi="90"
+   inkscape:export-ydpi="90">
+  <title
+     id="title3950">RTA Integration Overview</title>
+  <defs
+     id="defs4">
+    <marker
+       inkscape:stockid="Arrow2Lend"
+       orient="auto"
+       refY="0.0"
+       refX="0.0"
+       id="Arrow2Lend"
+       style="overflow:visible;">
+      <path
+         id="path4157"
+         style="font-size:12.0;fill-rule:evenodd;stroke-width:0.62500000;stroke-linejoin:round;"
+         d="M 8.7185878,4.0337352 L -2.2072895,0.016013256 L 8.7185884,-4.0017078 C 6.9730900,-1.6296469 6.9831476,1.6157441 8.7185878,4.0337352 z "
+         transform="scale(1.1) rotate(180) translate(1,0)" />
+    </marker>
+    <marker
+       inkscape:stockid="Arrow1Lend"
+       orient="auto"
+       refY="0.0"
+       refX="0.0"
+       id="Arrow1Lend"
+       style="overflow:visible;">
+      <path
+         id="path4139"
+         d="M 0.0,0.0 L 5.0,-5.0 L -12.5,0.0 L 5.0,5.0 L 0.0,0.0 z "
+         style="fill-rule:evenodd;stroke:#000000;stroke-width:1.0pt;marker-start:none;"
+         transform="scale(0.8) rotate(180) translate(12.5,0)" />
+    </marker>
+  </defs>
+  <sodipodi:namedview
+     id="base"
+     pagecolor="#ffffff"
+     bordercolor="#666666"
+     borderopacity="1.0"
+     inkscape:pageopacity="0.0"
+     inkscape:pageshadow="2"
+     inkscape:zoom="0.98994949"
+     inkscape:cx="338.47626"
+     inkscape:cy="723.66809"
+     inkscape:document-units="px"
+     inkscape:current-layer="layer1"
+     showgrid="false"
+     inkscape:window-width="1440"
+     inkscape:window-height="878"
+     inkscape:window-x="-8"
+     inkscape:window-y="-8"
+     inkscape:window-maximized="1" />
+  <metadata
+     id="metadata7">
+    <rdf:RDF>
+      <cc:Work
+         rdf:about="">
+        <dc:format>image/svg+xml</dc:format>
+        <dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
+        <dc:title>RTA Integration Overview</dc:title>
+      </cc:Work>
+    </rdf:RDF>
+  </metadata>
+  <g
+     inkscape:label="Layer 1"
+     inkscape:groupmode="layer"
+     id="layer1"
+     style="display:inline">
+    <rect
+       style="fill:#e5ffe5;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.94082779;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.9408278, 1.8816556;stroke-dashoffset:0"
+       id="rect2985"
+       width="533.80353"
+       height="200.01016"
+       x="82.832512"
+       y="49.280708"
+       ry="19.1929" />
+    <rect
+       style="fill:#99ffcc;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:1;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:1, 2;stroke-dashoffset:0"
+       id="rect3767"
+       width="101.01525"
+       height="53.538086"
+       x="243.44676"
+       y="73.524353"
+       ry="19.1929" />
+    <rect
+       style="fill:#99ffcc;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.81756771;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.81756773, 1.63513546;stroke-dashoffset:0"
+       id="rect3767-1"
+       width="101.01525"
+       height="35.785767"
+       x="243.44678"
+       y="159.89241"
+       ry="12.82886" />
+    <rect
+       style="fill:#ff66ff;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.81756771;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.81756773, 1.63513546;stroke-dashoffset:0"
+       id="rect3767-1-8"
+       width="101.01525"
+       height="35.785767"
+       x="490.93414"
+       y="81.895447"
+       ry="12.82886" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;font-family:Sans"
+       x="529.31989"
+       y="103.82895"
+       id="text3832"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan3834"
+         x="529.31989"
+         y="103.82895">RTA</tspan></text>
+    <rect
+       style="fill:#ffffcc;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.76365763;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.76365765, 1.5273153;stroke-dashoffset:0"
+       id="rect2985-5"
+       width="533.80353"
+       height="131.77383"
+       x="81.600868"
+       y="287.67673"
+       ry="12.644968" />
+    <rect
+       style="fill:#ff66ff;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.81756771;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.81756773, 1.63513546;stroke-dashoffset:0"
+       id="rect3767-1-8-1"
+       width="101.01525"
+       height="35.785767"
+       x="463.66003"
+       y="373.82953"
+       ry="12.82886" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;font-family:Sans"
+       x="500.61041"
+       y="395.72299"
+       id="text3832-5"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan3834-2"
+         x="500.61041"
+         y="395.72299">RTA</tspan></text>
+    <rect
+       style="fill:#ccecff;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.76365763;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.76365765, 1.5273153;stroke-dashoffset:0"
+       id="rect2985-5-7"
+       width="533.80353"
+       height="131.77383"
+       x="80.590714"
+       y="460.18579"
+       ry="12.644968" />
+    <rect
+       style="fill:#99ccff;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.30565068;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.30565068, 0.61130137;stroke-dashoffset:0"
+       id="rect2985-5-6"
+       width="203.08368"
+       height="55.48671"
+       x="248.03383"
+       y="519.5426"
+       ry="5.3244843" />
+    <flowRoot
+       xml:space="preserve"
+       id="flowRoot4061"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;font-family:Sans"><flowRegion
+         id="flowRegion4063"><rect
+           id="rect4065"
+           width="45.456863"
+           height="17.172594"
+           x="139.40105"
+           y="685.67682" /></flowRegion><flowPara
+         id="flowPara4067" /></flowRoot>    <path
+       style="fill:none;stroke:#000000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0;marker-end:url(#Arrow2Lend)"
+       d="M 344.46201,100.19032 490.93414,99.891405"
+       id="path4131"
+       inkscape:connector-type="polyline"
+       inkscape:connector-curvature="0"
+       inkscape:connection-start="#rect3767"
+       inkscape:connection-start-point="d4"
+       inkscape:connection-end="#rect3767-1-8"
+       inkscape:connection-end-point="d4" />
+    <path
+       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#Arrow2Lend)"
+       d="m 293.95439,127.06244 1e-5,32.82997"
+       id="path4763"
+       inkscape:connector-type="polyline"
+       inkscape:connector-curvature="0"
+       inkscape:connection-start="#rect3767"
+       inkscape:connection-start-point="d4"
+       inkscape:connection-end="#rect3767-1"
+       inkscape:connection-end-point="d4" />
+    <path
+       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#Arrow2Lend)"
+       d="m 440.96319,335.95105 49.7186,37.87848"
+       id="path5135"
+       inkscape:connector-type="polyline"
+       inkscape:connector-curvature="0"
+       inkscape:connection-start="#rect4101"
+       inkscape:connection-start-point="d4"
+       inkscape:connection-end="#rect3767-1-8-1"
+       inkscape:connection-end-point="d4" />
+    <path
+       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#Arrow2Lend)"
+       d="m 292.94424,193.73252 25.25381,338.4011"
+       id="path3067"
+       inkscape:connector-curvature="0" />
+    <path
+       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#Arrow2Lend)"
+       d="m 212.13204,394.75287 94.95433,137.38075"
+       id="path3069"
+       inkscape:connector-curvature="0" />
+    <path
+       style="fill:none;stroke:#000000;stroke-width:1.004;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#Arrow2Lend);stroke-miterlimit:4;stroke-dasharray:none"
+       d="m 273.75134,378.59043 189.28009,13.13199"
+       id="path3071"
+       inkscape:connector-curvature="0" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="103.62045"
+       y="71.464035"
+       id="text3832-1"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan3834-7"
+         x="103.62045"
+         y="71.464035">User space</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="99.680267"
+       y="313.51968"
+       id="text3832-1-4"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan3834-7-0"
+         x="99.680267"
+         y="313.51968">Kernel space</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="96.269417"
+       y="482.21518"
+       id="text3832-1-4-8"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan3834-7-0-8"
+         x="96.269417"
+         y="482.21518">Platform hardware</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;text-align:center;line-height:125%;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="294.0625"
+       y="94.316589"
+       id="text3832-1-2"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan3834-7-4"
+         x="294.0625"
+         y="94.316589">Crypto</tspan><tspan
+         sodipodi:role="line"
+         x="294.0625"
+         y="111.81659"
+         id="tspan3138">application</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;text-align:center;line-height:125%;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="295.19696"
+       y="182.62668"
+       id="text3832-1-2-5"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         x="295.19696"
+         y="182.62668"
+         id="tspan3138-1">QBMAN</tspan></text>
+  </g>
+  <g
+     inkscape:groupmode="layer"
+     id="layer2"
+     inkscape:label="Layer 2"
+     style="display:inline">
+    <rect
+       style="fill:#ccecff;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.10832807;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.10832807, 0.21665614;stroke-dashoffset:0;display:inline"
+       id="rect2985-5-7-3"
+       width="46.55518"
+       height="30.403757"
+       x="292.39508"
+       y="532.58911"
+       ry="2.9175332" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="308.09653"
+       y="552.33661"
+       id="text4015"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan4017"
+         x="308.09653"
+         y="552.33661">QI</tspan></text>
+    <rect
+       style="fill:#ccecff;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.10832807;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.10832807, 0.21665614;stroke-dashoffset:0;display:inline"
+       id="rect2985-5-7-3-2"
+       width="46.55518"
+       height="30.403757"
+       x="384.82404"
+       y="533.09424"
+       ry="2.9175332" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="397.49506"
+       y="551.8316"
+       id="text4015-2"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan4017-1"
+         x="397.49506"
+         y="551.8316">JRI</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="254.55844"
+       y="535.16406"
+       id="text4069"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan4071"
+         x="254.55844"
+         y="535.16406">SEC</tspan></text>
+    <rect
+       style="fill:#ffcc00;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.80089962;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.8008996, 1.6017992;stroke-dashoffset:0"
+       id="rect4101"
+       width="112.12693"
+       height="31.101717"
+       x="348.50262"
+       y="304.84933"
+       ry="3.415338" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;font-family:Sans"
+       x="369.71585"
+       y="325.0524"
+       id="text4103"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan4105"
+         x="369.71585"
+         y="325.0524">SEC Driver</tspan></text>
+    <rect
+       style="fill:#ffcc00;fill-opacity:1;fill-rule:nonzero;stroke:#ff0000;stroke-width:0.80738008;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.80738011, 1.61476021;stroke-dashoffset:0;display:inline"
+       id="rect4101-5"
+       width="111.56696"
+       height="31.765713"
+       x="162.08232"
+       y="362.38086"
+       ry="3.4882529" />
+    <text
+       xml:space="preserve"
+       style="font-size:14px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;display:inline;font-family:Sans"
+       x="177.28172"
+       y="383.64117"
+       id="text4103-7"
+       sodipodi:linespacing="125%"><tspan
+         sodipodi:role="line"
+         id="tspan4105-6"
+         x="177.28172"
+         y="383.64117">SEC QI Driver</tspan></text>
+  </g>
+</svg>
-- 
1.8.3.1
