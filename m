From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 05/17] pseries: Enabled the PFO-based RNG accelerator
Date: Thu, 22 Mar 2012 20:55:56 +1100
Message-ID: <20120322205556.054c6169@kryten>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	<1332365949.3858.32.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, rcj@linux.vnet.ibm.com,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Kent Yoder <key@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332365949.3858.32.camel@key-ThinkPad-W510>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hi,

+#if defined(CONFIG_HW_RANDOM_PSERIES) || \
+	defined(CONFIG_HW_RANDOM_PSERIES_MODULE)
+#define OV5_PFO_HW_RNG		0x80	/* PFO Random Number
Generator */ +#else
+#define OV5_PFO_HW_RNG		0x00
+#endif

Milton tipped me off about this. We really don't want to be doing
ibm,client-architecture reboots every time a config option is changed.

Let's just hardwire it on.

Anton
