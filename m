From: P J P <ppandit@redhat.com>
Subject: Re: [Part2 PATCH v4.1 07/29] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 4 Oct 2017 12:26:11 +0530 (IST)
Message-ID: <nycvar.YSQ.7.76.1710041221390.19122@wniryva>
References: <20170919204627.3875-8-brijesh.singh@amd.co> <20171002204831.5947-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: bp@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002204831.5947-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+-- On Mon, 2 Oct 2017, Brijesh Singh wrote --+
| +static int sev_cmd_buffer_len(int cmd)
| +{
| +	switch (cmd) {
| +	case SEV_CMD_INIT:		return sizeof(struct sev_data_init);
| +	case SEV_CMD_PLATFORM_STATUS:	return sizeof(struct sev_data_status);
| +	case SEV_CMD_PEK_CSR:		return sizeof(struct sev_data_pek_csr);
| +	case SEV_CMD_PEK_CERT_IMPORT:	return sizeof(struct sev_data_pek_cert_import);
| +	case SEV_CMD_PDH_CERT_EXPORT:	return sizeof(struct sev_data_pdh_cert_export);
| +	case SEV_CMD_LAUNCH_START:	return sizeof(struct sev_data_launch_start);
| +	case SEV_CMD_LAUNCH_UPDATE_DATA:return sizeof(struct sev_data_launch_update_data);
| +	case SEV_CMD_LAUNCH_UPDATE_VMSA:return sizeof(struct sev_data_launch_update_vmsa);
| +	case SEV_CMD_LAUNCH_FINISH:	return sizeof(struct sev_data_launch_finish);
| +	case SEV_CMD_LAUNCH_MEASURE:	return sizeof(struct sev_data_launch_measure);
| +	case SEV_CMD_ACTIVATE:		return sizeof(struct sev_data_activate);
| +	case SEV_CMD_DEACTIVATE:	return sizeof(struct sev_data_deactivate);
| +	case SEV_CMD_DECOMMISSION:	return sizeof(struct sev_data_decommission);
| +	case SEV_CMD_GUEST_STATUS:	return sizeof(struct sev_data_guest_status);
| +	case SEV_CMD_DBG_DECRYPT:	return sizeof(struct sev_data_dbg);
| +	case SEV_CMD_DBG_ENCRYPT:	return sizeof(struct sev_data_dbg);
| +	case SEV_CMD_SEND_START:       	return sizeof(struct sev_data_send_start);
| +	case SEV_CMD_SEND_UPDATE_DATA: 	return sizeof(struct sev_data_send_update_data);
| +	case SEV_CMD_SEND_UPDATE_VMSA: 	return sizeof(struct sev_data_send_update_vmsa);
| +	case SEV_CMD_SEND_FINISH:	return sizeof(struct sev_data_send_finish);
| +	case SEV_CMD_RECEIVE_START:	return sizeof(struct sev_data_receive_start);
| +	case SEV_CMD_RECEIVE_FINISH:	return sizeof(struct sev_data_receive_finish);
| +	case SEV_CMD_RECEIVE_UPDATE_DATA:return sizeof(struct sev_data_receive_update_data);
| +	case SEV_CMD_RECEIVE_UPDATE_VMSA:return sizeof(struct sev_data_receive_update_vmsa);
| +	case SEV_CMD_LAUNCH_UPDATE_SECRET:return sizeof(struct sev_data_launch_secret);
| +	default:			return 0;
| +	}

Each return above needs to be on its own line.

--
 - P J P
47AF CE69 3A90 54AA 9045 1053 DD13 3D32 FE5B 041F
