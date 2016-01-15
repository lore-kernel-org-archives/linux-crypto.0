From: Dave Young <dyoung@redhat.com>
Subject: Re: Kexec_file_load failed with "Missing required AuthAttr"
Date: Fri, 15 Jan 2016 16:12:49 +0800
Message-ID: <20160115081249.GA19487@dhcp-128-65.nay.redhat.com>
References: <20160107052507.GA12900@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, xlpang@redhat.com, vgoyal@redhat.com,
	pjones@redhat.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbcAOINE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 03:13:04 -0500
Content-Disposition: inline
In-Reply-To: <20160107052507.GA12900@dhcp-128-65.nay.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ccing Peter Jones for pesign possible issues. 

On 01/07/16 at 01:25pm, Dave Young wrote:
> Hi,
> 
> I saw the warning "Missing required AuthAttr" when testing kexec, known issue?
> Idea about how to fix it?
> 
> The kernel is latest linus tree plus sevral patches from Toshi to cleanup io resource structure.
> 
> in function pkcs7_sig_note_set_of_authattrs():
>         if (!test_bit(sinfo_has_content_type, &sinfo->aa_set) ||
>             !test_bit(sinfo_has_message_digest, &sinfo->aa_set) ||
>             (ctx->msg->data_type == OID_msIndirectData &&
>              !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))) {
>                 pr_warn("Missing required AuthAttr\n");
>                 return -EBADMSG;
>         }
> 
> The third condition below is true:
> (ctx->msg->data_type == OID_msIndirectData &&
>              !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))
> 
> I signed the kernel with redhat test key like below:
> pesign -c 'Red Hat Test Certificate' -i arch/x86/boot/bzImage -o /boot/vmlinuz-4.4.0-rc8+ -s --force
> 
> Thanks
> Dave
