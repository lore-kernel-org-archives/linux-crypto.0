From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v4.1 07/29] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 4 Oct 2017 12:07:49 +0200
Message-ID: <20171004100749.433dzszyea3oqcpn@pd.tnic>
References: <20170919204627.3875-8-brijesh.singh@amd.co>
 <20171002204831.5947-1-brijesh.singh@amd.com>
 <nycvar.YSQ.7.76.1710041221390.19122@wniryva>
 <20171004092152.4lmjlsqrg25dgaxu@pd.tnic>
 <nycvar.YSQ.7.76.1710041515170.22210@wniryva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: P J P <ppandit@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54515 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751223AbdJDKIL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2017 06:08:11 -0400
Content-Disposition: inline
In-Reply-To: <nycvar.YSQ.7.76.1710041515170.22210@wniryva>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 04, 2017 at 03:24:36PM +0530, P J P wrote:
> It appears to cross 80 columns limit, checkpatch.pl throws warnings. Adding 
> new line would be consistent with coding style.

The 80 cols rule is not a hard one and checkpatch should not override
common sense. This is a function which maps commands to buffer lengths
and it should be obvious at a *very* quick glance what it does. And that
is best done if it is written in a tabular manner as we do such things
in other places in the kernel too.

Btw, Brijesh, please space out those statements for even better
readability:

static int sev_cmd_buffer_len(int cmd)
{
       switch (cmd) {
       case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
       case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_data_status);
       case SEV_CMD_PEK_CSR:           		return sizeof(struct sev_data_pek_csr);
       case SEV_CMD_PEK_CERT_IMPORT:   		return sizeof(struct sev_data_pek_cert_import);
       case SEV_CMD_PDH_CERT_EXPORT:   		return sizeof(struct sev_data_pdh_cert_export);
       case SEV_CMD_LAUNCH_START:      		return sizeof(struct sev_data_launch_start);
       case SEV_CMD_LAUNCH_UPDATE_DATA:		return sizeof(struct sev_data_launch_update_data);
       case SEV_CMD_LAUNCH_UPDATE_VMSA:		return sizeof(struct sev_data_launch_update_vmsa);
       case SEV_CMD_LAUNCH_FINISH:     		return sizeof(struct sev_data_launch_finish);
       case SEV_CMD_LAUNCH_MEASURE:    		return sizeof(struct sev_data_launch_measure);
       case SEV_CMD_ACTIVATE:          		return sizeof(struct sev_data_activate);
       case SEV_CMD_DEACTIVATE:        		return sizeof(struct sev_data_deactivate);
       case SEV_CMD_DECOMMISSION:      		return sizeof(struct sev_data_decommission);
       case SEV_CMD_GUEST_STATUS:      		return sizeof(struct sev_data_guest_status);
       case SEV_CMD_DBG_DECRYPT:       		return sizeof(struct sev_data_dbg);
       case SEV_CMD_DBG_ENCRYPT:		return sizeof(struct sev_data_dbg);
       case SEV_CMD_SEND_START:			return sizeof(struct sev_data_send_start);
       case SEV_CMD_SEND_UPDATE_DATA:		return sizeof(struct sev_data_send_update_data);
       case SEV_CMD_SEND_UPDATE_VMSA:		return sizeof(struct sev_data_send_update_vmsa);
       case SEV_CMD_SEND_FINISH:		return sizeof(struct sev_data_send_finish);
       case SEV_CMD_RECEIVE_START:		return sizeof(struct sev_data_receive_start);
       case SEV_CMD_RECEIVE_FINISH:    		return sizeof(struct sev_data_receive_finish);
       case SEV_CMD_RECEIVE_UPDATE_DATA:	return sizeof(struct sev_data_receive_update_data);
       case SEV_CMD_RECEIVE_UPDATE_VMSA:	return sizeof(struct sev_data_receive_update_vmsa);
       case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
       default:                        		return 0;
       }

       return 0;
}

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
