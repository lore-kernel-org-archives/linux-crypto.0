From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Kexec_file_load failed with "Missing required AuthAttr"
Date: Thu, 7 Jan 2016 13:25:07 +0800
Message-ID: <20160107052507.GA12900@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: xlpang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I saw the warning "Missing required AuthAttr" when testing kexec, known issue?
Idea about how to fix it?

The kernel is latest linus tree plus sevral patches from Toshi to cleanup io resource structure.

in function pkcs7_sig_note_set_of_authattrs():
        if (!test_bit(sinfo_has_content_type, &sinfo->aa_set) ||
            !test_bit(sinfo_has_message_digest, &sinfo->aa_set) ||
            (ctx->msg->data_type == OID_msIndirectData &&
             !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))) {
                pr_warn("Missing required AuthAttr\n");
                return -EBADMSG;
        }

The third condition below is true:
(ctx->msg->data_type == OID_msIndirectData &&
             !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))

I signed the kernel with redhat test key like below:
pesign -c 'Red Hat Test Certificate' -i arch/x86/boot/bzImage -o /boot/vmlinuz-4.4.0-rc8+ -s --force

Thanks
Dave
