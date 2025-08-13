Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064D62F83B7
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755086618; cv=none; b=FlahX12nUXG/LyO/xJ8O/oAfiSbK2u7soioC0wfqGxBIkS/8t3OnMqK2BXD6UiAopk5pWSHPvEQ116B0Kj8iSZNXjrDLuZXwcnmxDTkCYNXkdrW15/1hJLFMjDxPUht2O9v8j+YQqOnvMcd2Zm6SfuXprepik+lNumhN2ZMabDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755086618; c=relaxed/simple;
	bh=EPVYWuW7TR+vupadSGWwd4VuG97Hx6QV5vRrVUJ+DmA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=GyWl27rAJLyOpwip/mcu0Ae/jxbrdahYheo9C7/rZ/FigVskjx8eLySXoQ+lbQUZ7GFijx1DdeaBAqdDs51tkfUjSSBIduKflPivWqfu01UUqKfT/s1xGTViyf3AWxRxojVaIM+DFW9ctUEa3CfQS9oUDzURc+RehMA7TEuHRqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O7fLhuDG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O7fLhuDG"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DBCJUF029460;
	Wed, 13 Aug 2025 12:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:subject:to; s=pp1; bh=EPVYWuW7TR+vupadSGWwd4VuG97Hx6QV5vRrVUJ+D
	mA=; b=O7fLhuDGQp57RVVmTeKyRpjkAw9YaIIkOxBMS1aRHoV63TpZ6kBUpuAxP
	oKER8qtpA3zv+94P+6XEvki9q4/f+xnLAcAMt7q6Do3v4/iseFutdsoXU+NoLa8O
	F1mDO2CTTuPAr9EOVWn2LvbiNdqaPUEyy7tyTn8rta+EOebGd+YmrpY0/Dl/Yb8Z
	Ow7FrNblfVx3koRkQootHZkT8NhkGqnVtYy70smjM23tfATA78oZf1PPIioinWH5
	H3u4mHAPP63RqQ1WlNwEkn7bYKPnnEsi1fLsS2dS9+wR5FtozHJmpfPiU5fvjO7w
	QCWt8gcVOt3zW7/4zMGCIO5TlxU+A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwudca19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 12:03:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D8e7o4017600;
	Wed, 13 Aug 2025 12:03:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc3pt7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 12:03:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DC3TRO41419140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 12:03:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5646D2004B;
	Wed, 13 Aug 2025 12:03:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F75E20049;
	Wed, 13 Aug 2025 12:03:29 +0000 (GMT)
Received: from localhost (unknown [9.155.200.179])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 12:03:29 +0000 (GMT)
From: Alexander Egorenkov <egorenar@linux.ibm.com>
To: jstancek@redhat.com
Cc: herbert@gondor.apana.org.au, jforbes@redhat.com,
        linux-crypto@vger.kernel.org, lukas@wunner.de
Subject: Re: [bug] pkcs1(rsa-generic,sha256) sign test and RSA selftest
 failures, possibly related to sig_alg backend changes
In-Reply-To: <CAASaF6wYCo9TbY7nWzu6cS9ou4VXv2P=dROK-Jt8ik5jX-N2EQ@mail.gmail.com>
Date: Wed, 13 Aug 2025 14:03:28 +0200
Message-ID: <87plczcttb.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX62jEljIxP71c
 DbQWL6R5nK4rM+9UWJ5B2eiR/MlWVPc+Kvjrv0qXT04Q6PiRDuZaTnI9EKej1U5nYNcfxyYW1EY
 QupRyaLtJmN7fUJJISSRddzUAS7HPSVX4KYl9LlgcQSlAr3BVO24PambMArl41G71dEmmbYT662
 n9br7f6g8OVXviKi0yX0q4g+vFVZ7DlFqp8013B2Sw+1fFjeIdzjp8m5zbLAun+E5nE1Rn6U4/H
 PMvu9jcJk29pq9w53/PwS6qmgiMpQde7Pgjtco3KLCGH6C1UfN64uM5g1YdyXd/8S1J+CkV626P
 UNbseeVkxU6RZLHQOxwprell6sZGrQK75XqmAKe3ymiv7QPlDqOfMfzj+5l0I63KbuFFRRBKK5K
 VJCoVM2W
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689c7f14 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=5thrDFmy61Qw1jrvmjAA:9
X-Proofpoint-GUID: qiJSGasRcSGGHTzpfCskOwaEuOoolKXq
X-Proofpoint-ORIG-GUID: qiJSGasRcSGGHTzpfCskOwaEuOoolKXq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224

Hi Jan,

i hit this problem on Fedora 42 x86 and s390x now but with "keyctl
pkey_sign". My Fedora kernel releases: 6.15.9-201.fc42.x86_64 and 6.15.9-201.fc42.s390x.
Do you know what is the problem and how to fix it ?

It seems to work with the latest vanilla Linux kernel on s390x (and i
assume on x86 would too, but not tested), so i assume Fedora's kernel is
somehow different here.

Kernel's PKCS1 sig algorithm seems to call sig_default_sign() instead of
rsassa_pkcs1_sign() and the former returns -ENOSYS which is propagated
to user space, in my case keyctl.

Regards
Alex
