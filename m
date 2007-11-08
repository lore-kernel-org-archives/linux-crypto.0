From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: improper initialization of ipsec_table  in openswan 2.4.9
Date: Thu, 8 Nov 2007 10:29:13 +1000
Message-ID: <20071108002913.GA27507@securecomputing.com>
References: <537818.31005.qm@web62507.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Cc: linux-crypto@vger.kernel.org, dev@lists.openswan.org
To: Eran Ben-Avi <eranpublic@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:48967 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081AbXKHA1z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Nov 2007 19:27:55 -0500
Content-Disposition: inline
In-Reply-To: <537818.31005.qm@web62507.mail.re1.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Jivin Eran Ben-Avi lays it down ...
> Hi,
> 
> While working with openswan 2.4.9  on kernel 2.6.22.7 I found a bug in file sysctl_net_ipsec.c.
> The initialization of ipsec_table is improper for newer kernel versions since ctl_table structure was updated.
> The 7th parameter which refer to *parent was initialized mistakenly with *proc_handler as it was in older kernel versions.
> As a result ipsec proc entries under /proc/sys/net/ipsec were created as directories instead of files which led  to improper behavior of openswan.
> Patch attached - the patch is only for newer kernel versions.Ofcourse it should be updated for backward compatibility.

The newly released 2.4.10 version has a fix for this included,  but it
only names the one field to avoid the structure alignment changes.
Probably more a topic for the openswan dev list.

I figure it needs to be more like the attached changes to 2.4.9 going forward.
Will repost one I update to 2.4.10 (and then probably 2.5...) ;-)

Cheers,
Davidm

> --- linux/net/ipsec/sysctl_net_ipsec.c	2004-07-10 17:11:18.000000000 -0200
> +++ ../openswan-2.4.9_a/linux/net/ipsec/sysctl_net_ipsec.c	2007-11-06 11:13:13.000000000 -0200
> @@ -74,45 +74,45 @@
>  static ctl_table ipsec_table[] = {
>  #ifdef CONFIG_KLIPS_DEBUG
>  	{ NET_IPSEC_DEBUG_AH, "debug_ah", &debug_ah,
> -	  sizeof(int), 0644, NULL, &proc_dointvec},    
> +	  sizeof(int), 0644, NULL, NULL, &proc_dointvec},    
>  	{ NET_IPSEC_DEBUG_ESP, "debug_esp", &debug_esp,
> -	  sizeof(int), 0644, NULL, &proc_dointvec},    
> +	  sizeof(int), 0644, NULL, NULL, &proc_dointvec},    
....


-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com

--EeQfGwPcQSOJBaQU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="sysctl.diff"

Index: openswan/linux/net/ipsec/sysctl_net_ipsec.c
===================================================================
RCS file: /cvs/sw/new-wave/openswan/linux/net/ipsec/sysctl_net_ipsec.c,v
retrieving revision 1.2
diff -u -r1.2 sysctl_net_ipsec.c
--- openswan/linux/net/ipsec/sysctl_net_ipsec.c	26 Apr 2007 13:21:26 -0000	1.2
+++ openswan/linux/net/ipsec/sysctl_net_ipsec.c	8 Nov 2007 00:21:08 -0000
@@ -73,58 +73,171 @@
 };
 
 static ctl_table ipsec_table[] = {
+
 #ifdef CONFIG_KLIPS_DEBUG
-	{ NET_IPSEC_DEBUG_AH, "debug_ah", &debug_ah,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_ESP, "debug_esp", &debug_esp,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_TUNNEL, "debug_tunnel", &debug_tunnel,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_EROUTE, "debug_eroute", &debug_eroute,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_SPI, "debug_spi", &debug_spi,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_RADIJ, "debug_radij", &debug_radij,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_NETLINK, "debug_netlink", &debug_netlink,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_XFORM, "debug_xform", &debug_xform,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_RCV, "debug_rcv", &debug_rcv,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_PFKEY, "debug_pfkey", &debug_pfkey,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_DEBUG_VERBOSE, "debug_verbose",&sysctl_ipsec_debug_verbose,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_AH,
+		.procname     = "debug_ah",
+		.data         = &debug_ah,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_ESP,
+		.procname     = "debug_esp",
+		.data         = &debug_esp,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_TUNNEL,
+		.procname     = "debug_tunnel",
+		.data         = &debug_tunnel,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_EROUTE,
+		.procname     = "debug_eroute",
+		.data         = &debug_eroute,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_SPI,
+		.procname     = "debug_spi",
+		.data         = &debug_spi,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_RADIJ,
+		.procname     = "debug_radij",
+		.data         = &debug_radij,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_NETLINK,
+		.procname     = "debug_netlink",
+		.data         = &debug_netlink,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_XFORM,
+		.procname     = "debug_xform",
+		.data         = &debug_xform,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_RCV,
+		.procname     = "debug_rcv",
+		.data         = &debug_rcv,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_PFKEY,
+		.procname     = "debug_pfkey",
+		.data         = &debug_pfkey,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_VERBOSE,
+		.procname     = "debug_verbose",
+		.data         = &sysctl_ipsec_debug_verbose,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
 #ifdef CONFIG_KLIPS_IPCOMP
-	{ NET_IPSEC_DEBUG_IPCOMP, "debug_ipcomp", &sysctl_ipsec_debug_ipcomp,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
+	{
+		.ctl_name     = NET_IPSEC_DEBUG_IPCOMP,
+		.procname     = "debug_ipcomp",
+		.data         = &sysctl_ipsec_debug_ipcomp,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
 #endif /* CONFIG_KLIPS_IPCOMP */
 
 #ifdef CONFIG_KLIPS_REGRESS
-	{ NET_IPSEC_REGRESS_PFKEY_LOSSAGE, "pfkey_lossage",
-	  &sysctl_ipsec_regress_pfkey_lossage,
-	  sizeof(int), 0644, NULL, &proc_dointvec},
+	{
+		.ctl_name     = NET_IPSEC_REGRESS_PFKEY_LOSSAGE,
+		.procname     = "pfkey_lossage",
+		.data         = &sysctl_ipsec_regress_pfkey_lossage,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
 #endif /* CONFIG_KLIPS_REGRESS */
 
 #endif /* CONFIG_KLIPS_DEBUG */
-	{ NET_IPSEC_ICMP, "icmp", &sysctl_ipsec_icmp,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_INBOUND_POLICY_CHECK, "inbound_policy_check", &sysctl_ipsec_inbound_policy_check,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{ NET_IPSEC_TOS, "tos", &sysctl_ipsec_tos,
-	  sizeof(int), 0644, NULL, &proc_dointvec},    
-	{0}
+
+	{
+		.ctl_name     = NET_IPSEC_ICMP,
+		.procname     = "icmp",
+		.data         = &sysctl_ipsec_icmp,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_INBOUND_POLICY_CHECK,
+		.procname     = "inbound_policy_check",
+		.data         = &sysctl_ipsec_inbound_policy_check,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = NET_IPSEC_TOS,
+		.procname     = "tos",
+		.data         = &sysctl_ipsec_tos,
+		.maxlen       = sizeof(int),
+		.mode         = 0644,
+		.proc_handler = &proc_dointvec
+	},
+	{
+		.ctl_name     = 0
+	}
 };
 
 static ctl_table ipsec_net_table[] = {
-        { NET_IPSEC, "ipsec", NULL, 0, 0555, ipsec_table },
-        { 0 }
+	{
+		.ctl_name     = NET_IPSEC,
+		.procname     = "ipsec",
+		.mode         = 0555,
+		.child        = ipsec_table
+	},
+	{
+		.ctl_name     = 0
+	}
 };
  
 static ctl_table ipsec_root_table[] = {
-        { CTL_NET, "net", NULL, 0, 0555, ipsec_net_table },
-        { 0 }
+	{
+		.ctl_name     = CTL_NET,
+		.procname     = "net",
+		.mode         = 0555,
+		.child        = ipsec_net_table
+	},
+	{
+		.ctl_name     = 0
+	}
 };
  
 static struct ctl_table_header *ipsec_table_header;

--EeQfGwPcQSOJBaQU--
